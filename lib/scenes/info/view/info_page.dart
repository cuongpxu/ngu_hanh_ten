import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ngu_hanh_ten/utils/consts.dart';
import 'package:ngu_hanh_ten/utils/adsId.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  double adsHeight = 60.0;
  BannerAd _ad;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    super.dispose();
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
                    alignment: Alignment.center,
                    child: _ad == null ? Container() : AdWidget(ad: _ad),
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
