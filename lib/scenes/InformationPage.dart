import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

import '../utils/consts.dart';
import '../utils/adsId.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  double adsHeight = 0;
  final nativeAdController = NativeAdmobController();
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    nativeAdController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(nguHanhPageTitle), backgroundColor: Color(0xffB2210D)),
      body: SingleChildScrollView(
          child: Container(
              color: Color(0xFFF9F3CC),
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
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
                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Center(
                      child: Text(infor1,
                          style: TextStyle(height: 1.5),
                          textAlign: TextAlign.justify),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Center(
                      child: Text(infor2,
                          style: TextStyle(height: 1.5),
                          textAlign: TextAlign.justify),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Center(
                      child: Text(infor3,
                          style: TextStyle(height: 1.5),
                          textAlign: TextAlign.justify),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Center(
                      child: Text(infor4,
                          style: TextStyle(height: 1.5),
                          textAlign: TextAlign.justify),
                    ),
                  )
                ],
              ))),
    );
  }
}
