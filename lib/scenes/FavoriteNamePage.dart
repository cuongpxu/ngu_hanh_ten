import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import '../models/NguHanhInput.dart';
import '../utils/adsId.dart';
import '../databases/localDB.dart';
import '../utils/consts.dart';
import 'NguHanhDetailPage.dart';

class FavoriteNamePage extends StatefulWidget {
  @override
  _FavoriteNamePageState createState() => _FavoriteNamePageState();
}

class _FavoriteNamePageState extends State<FavoriteNamePage> {
  double adsHeight = 0;
  final nativeAdController = NativeAdmobController();
  StreamSubscription _subscription;

  List<NguHanhInput> lstNHI = [];

  @override
  void initState() {
    _subscription = nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
    getData();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          adsHeight = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          adsHeight = 90;
        });
        break;
      default:
        break;
    }
  }

  getData() async {
    await DBProvider.db.getAllFavoriteName().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          lstNHI = value;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: adsHeight,
                child: NativeAdmob(
                  adUnitID: getNativeAdUnitId(),
                  numberAds: 3,
                  controller: nativeAdController,
                  type: NativeAdmobType.banner,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                child: Center(
                  child: Text(favoritePageTitle.toUpperCase(),
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ThuPhap')),
                ),
              ),
              _buildList(context)
            ],
          ))),
    );
  }

  Widget _buildList(BuildContext context) {
    if (lstNHI.isEmpty) {
      return Container(
        child: Center(
          child: Text(noData,
              style: TextStyle(height: 1.5, fontWeight: FontWeight.bold)),
        ),
      );
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          ...lstNHI.map((e) {
            int idx = lstNHI.indexOf(e);
            return _buildListItem(context, e, idx);
          }).toList()
        ]));
  }

  Widget _buildListItem(BuildContext context, NguHanhInput nhi, int index) {
    return Container(
        width: MediaQuery.of(context).size.width,
//        decoration: (index % 2) == 0 ? BoxDecoration(color: Colors.grey.withOpacity(0.3)) : null,
        child: Column(children: [
          Card(
              child: new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NguHanhDetailPage(nhi: nhi),
                  ));
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFF9F3CC),
                padding: EdgeInsets.all(10.0),
                child: Text("${nhi.surname} ${nhi.firstname}",
                    style: TextStyle(height: 1.5, fontWeight: FontWeight.bold)),
              ),
            ),
          )),
        ]));
  }
}
