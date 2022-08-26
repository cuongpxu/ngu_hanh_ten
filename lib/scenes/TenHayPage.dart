import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import '../databases/localDB.dart';
import '../models/NguHanhTen.dart';
import '../utils/commons.dart';
import '../utils/consts.dart';
import '../utils/colors.dart';
import '../utils/adsId.dart';

class TenHayPage extends StatefulWidget {
  @override
  _TenHayPageState createState() => _TenHayPageState();
}

class _TenHayPageState extends State<TenHayPage> {
  double adsHeight = 0;
  final nativeAdController = NativeAdmobController();
  StreamSubscription _subscription;

  final TextEditingController nameTEC = TextEditingController();
  ScrollController _scrollController = ScrollController();

  List<String> _menhChoices = [allType, "Kim", "Mộc", "Thủy", "Hỏa", "Thổ"];
  String _choice = allType;
  List<NguHanhTen> data = [];
  int offset = 0;
  bool hasMoreData = true;

  @override
  void initState() {
    _subscription = nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    nameTEC.addListener(_resetOffsetWhenNameSearchChanged);
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

  void _resetOffsetWhenNameSearchChanged() {
    setState(() {
      this.offset = 0;
    });
  }

  void _getMoreData() async {
    if (_choice != allType) {
      await DBProvider.db
          .get50NamesByType(nameTEC.text, _choice, offset)
          .then((value) {
        setState(() {
          this.data.addAll(value);
          this.offset += value.length;
          if (value.isEmpty) {
            this.hasMoreData = false;
          }
        });
      });
    } else {
      await DBProvider.db.get50Names(nameTEC.text, offset).then((value) {
        setState(() {
          this.data.addAll(value);
          this.offset += value.length;
          if (value.isEmpty) {
            this.hasMoreData = false;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
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
                  child: Text(tenHayPageTitle.toUpperCase(),
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ThuPhap')),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextFormField(
                  controller: nameTEC,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: firstname,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelStyle: new TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 10, 0.0, 10),
                child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Mệnh",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelStyle: new TextStyle(color: Colors.white),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: new Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Color(0xFFF9F3CC),
                        ),
                        child: DropdownButton<String>(
                          value: _choice,
                          style: TextStyle(color: Colors.black),
                          onChanged: (String newValue) {
                            setState(() {
                              _choice = newValue;
                              offset = 0;
                              hasMoreData = true;
                            });
                          },
                          items: _menhChoices.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(color: getColorByType(value), fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          isDense: true,
                        ),
                      ),
                    )),
              ),
              Center(
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return secondColor;
                        return primaryColor; // Use the component's default.
                      },
                    )),
                    child: Text(findTitle,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (_choice != allType) {
                        DBProvider.db
                            .get50NamesByType(nameTEC.text, _choice, offset)
                            .then((value) {
                          setState(() {
                            this.data = value;
                            this.offset += value.length;
                            if (value.isEmpty) {
                              this.hasMoreData = false;
                            }
                          });
                        });
                      } else {
                        DBProvider.db
                            .get50Names(nameTEC.text, offset)
                            .then((value) {
                          setState(() {
                            this.data = value;
                            this.offset += value.length;
                            if (value.isEmpty) {
                              this.hasMoreData = false;
                            }
                          });
                        });
                      }
                    }),
              ),
              _buildList(context, data)
            ],
          ))),
    );
  }

  Widget _buildList(BuildContext context, List<NguHanhTen> data) {
    if (data == null) {
      return Container();
    }
    if (data.isEmpty) {
      return Container();
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Row(children: [
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Tên",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white)),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Mệnh",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white)),
                )),
          ]),
          Divider(),
          ...data.map((e) {
            int idx = data.indexOf(e);
            return _buildListItem(context, e, idx);
          }).toList()
        ]));
  }

  Widget _buildListItem(BuildContext context, NguHanhTen nht, int index) {
    if ((index + 1) == this.data.length && this.hasMoreData) {
      return CupertinoActivityIndicator();
    }

    return Container(
        width: MediaQuery.of(context).size.width,
//        decoration: (index % 2) == 0
//            ? BoxDecoration(color: Color(0xFFF9F3CC).withOpacity(0.5))
//            : null,
        decoration: BoxDecoration(color: Color(0xFFF9F3CC)),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(nht.name, style: TextStyle(height: 1.5, color: getColorByType(nht.type), fontWeight: FontWeight.bold)),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: highlightType(context, nht.type),
                  )),
            ],
          ),
        ]));
  }
}
