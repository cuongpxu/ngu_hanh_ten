import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../databases/localDB.dart';
import '../models/NguHanhInput.dart';
import '../models/TongQuan.dart';
import '../models/NguHanhScore.dart';
import '../models/NguHanhTen.dart';
import '../models/NienMenh.dart';
import '../models/CungMenh.dart';
import '../utils/colors.dart';
import '../utils/consts.dart';
import '../utils/lunars.dart';
import '../utils/commons.dart';
import '../utils/adsId.dart';

class NguHanhDetailPage extends StatefulWidget {
  final NguHanhInput nhi;

  NguHanhDetailPage({this.nhi});

  @override
  _NguHanhDetailPageState createState() =>
      _NguHanhDetailPageState(nhi: this.nhi);
}

class _NguHanhDetailPageState extends State<NguHanhDetailPage> {
  NguHanhInput nhi;
  SolarLunarConverter slc;
  int totalScore;
  TongQuan tq;
  List<NguHanhScore> lstNguHanhScore;
  List<NienMenh> lstNienMenh;
  List<NguHanhTen> lstNHTNames;

  IconData iconData = Icons.favorite_border;

  double adsHeight = 0;
  final nativeAdController = NativeAdmobController();
  StreamSubscription _subscription;

  InterstitialAd _interstitialAd;
  bool _interstitialReady ;

  _NguHanhDetailPageState({this.nhi});

  @override
  void initState() {
    _subscription = nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
    getData();
    getNHTNames();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
          tagForChildDirectedTreatment:
          TagForChildDirectedTreatment.unspecified))
          .then((value) {
        createInterstitialAd();
      });
    });
  }

  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: getInterstitialAdUnitId(),
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          _interstitialReady = false;
          createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          _interstitialAd = null;
          _interstitialReady = false;
          Navigator.of(context).pop();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
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
    await getListNienMenhForFamily(this.nhi).then((List<NienMenh> lst) {
      setState(() {
        lstNienMenh = lst;
      });
    });

    await getListNHScore().then((List<NguHanhScore> lst) {
      setState(() {
        lstNguHanhScore = lst;
      });
    });

    await DBProvider.db.getFavoriteNameByFields(nhi).then((value) {
      if (value != null) {
        setState(() {
          this.nhi = value;
        });
      }
    });
  }

  getNHTNames() async {
    var fullname = "${nhi.surname} ${nhi.firstname}";
    var names = fullname.trim().split(' ');
    List<NguHanhTen> nhtNames = [];
    for (int i = 0; i < names.length; i++) {
      NguHanhTen nht = await DBProvider.db.getNguHanhTenByName(names[i]);
      if (nht == null) {
        nht = new NguHanhTen();
        nht.name = names[i];
        nht.type = undefined_type;
      }
      nhtNames.add(nht);
    }
    setState(() {
      this.lstNHTNames = nhtNames;
    });
  }

  Future<TongQuan> getGeneralAnalysis() async {
    TongQuan tq = new TongQuan();
    tq.expectedName = "${nhi.surname.trim()} ${nhi.firstname.trim()}";
    var names = tq.expectedName.split(' ');
    String nguHanhTenChitiet = "";
    for (int i = 0; i < names.length; i++) {
      NguHanhTen nhti;
      await DBProvider.db.getNguHanhTenByName(names[i]).then((NguHanhTen nht) {
        if (nht == null) {
          nht = new NguHanhTen();
          nht.name = names[i];
          nht.type = undefined_type;
        }
        nhti = nht;
      });
      String t = "- Chữ ${nhti.name} thuộc hành ${nhti.type}.";
      nguHanhTenChitiet += t + "\n";
    }

    NguHanhTen nhtCon = new NguHanhTen(type: lstNienMenh.last.menh);
    List<String> nhTuongSinh = nhtCon.getNguHanhTuongSinh();
    String t =
        "- ${lstNienMenh.last.who} có mệnh: ${nhtCon.type} tương sinh với các tên có hành ${nhTuongSinh.first} và ${nhTuongSinh.last}.";
    nguHanhTenChitiet += t;
    tq.expectedNameBreakDown = nguHanhTenChitiet;
    tq.score = "$totalScore/12";
    tq.conclusion = nhi.getGeneralConclusionByScore(totalScore);
    return tq;
  }

  Future<List<NguHanhScore>> getListNHScore() async {
    List<NguHanhScore> lstNguHanhScore = [];
    var names = nhi.firstname.trim().split(" ");
    String firstNameCon = names.last;
    NguHanhTen nhtCon;
    await DBProvider.db
        .getNguHanhTenByName(firstNameCon)
        .then((NguHanhTen nht) {
      if (nht == null) {
        nhtCon = new NguHanhTen();
        nhtCon.name = firstNameCon;
        nhtCon.type = undefined_type;
      } else {
        nhtCon = nht;
      }
    });

    // Con
    NguHanhScore nhs = new NguHanhScore();
    nhs.title = "Quan hệ giữa tên và bản mệnh";
    nhs.content1Title = "Hành của tên: ";
    nhs.content1 = nhtCon.type;
    String banMenh = lstNienMenh.last.menh;
    nhs.content2Title = "Hành của bản mệnh: ";
    nhs.content2 = banMenh;
    nhs.score = nhi.getScore(nhtCon, new NguHanhTen(type: banMenh));
    if (nhs.score == 2) nhs.score += 1;
    nhs.content3Title = concludeTitle;
    nhs.content3 =
        nhi.getConclusion(nhs.score, "tên", nhtCon.type, "bản mệnh", banMenh);
    nhs.scoreTitle = "Điểm:";
    nhs.score = nhs.score;
    nhs.scoreText = "${nhs.score}/3";
    lstNguHanhScore.add(nhs);

    // Cha
    NguHanhScore nhsCha = new NguHanhScore();
    nhsCha.title = "Quan hệ giữa Hành của cha và Hành tên con";
    nhsCha.content1Title = "Hành của bản mệnh cha: ";
    String banMenhCha = lstNienMenh.first.menh;
    nhsCha.content1 = banMenhCha;
    nhsCha.content2Title = "Hành của tên con: ";
    nhsCha.content2 = banMenh;
    nhsCha.score = nhi.getScore(nhtCon, new NguHanhTen(type: banMenhCha));
    if (nhsCha.score == 2) nhsCha.score += 1;
    nhsCha.content3Title = concludeTitle;
    nhsCha.content3 = nhi.getConclusion(
        nhsCha.score, "bản mệnh cha", banMenhCha, "tên con", nhtCon.type);
    nhsCha.scoreTitle = "Điểm:";
    nhsCha.score = nhsCha.score;
    nhsCha.scoreText = "${nhsCha.score}/3";
    lstNguHanhScore.add(nhsCha);

    // Me
    NguHanhScore nhsMe = new NguHanhScore();
    nhsMe.title = "Quan hệ giữa Hành của mẹ và Hành tên con";
    nhsMe.content1Title = "Hành của bản mệnh mẹ: ";
    String banMenhMe = lstNienMenh.elementAt(1).menh;
    nhsMe.content1 = banMenhMe;
    nhsMe.content2Title = "Hành của tên con: ";
    nhsMe.content2 = banMenh;
    nhsMe.score = nhi.getScore(nhtCon, new NguHanhTen(type: banMenhMe));
    if (nhsMe.score != 0) nhsMe.score += 1;
    nhsMe.content3Title = concludeTitle;
    nhsMe.content3 = nhi.getConclusion(
        nhsMe.score, "bản mệnh mẹ", banMenhMe, "tên con", nhtCon.type);
    nhsMe.scoreTitle = "Điểm:";
    nhsMe.scoreText = "${nhsMe.score}/3";
    lstNguHanhScore.add(nhsMe);

    // Ten
    NguHanhScore nhsTen = new NguHanhScore();
    nhsTen.title = "Quan hệ giữa Họ, Tên đệm và Tên";

    await nhi.getAllRelationshipName().then((value) {
      nhsTen.content1 = value;
    });
    nhsTen.content2 = "";
    nhsTen.content3 = "";
    await nhi.getScoreName().then((value) {
      nhsTen.score = value;
    });
    nhsTen.scoreTitle = "Điểm:";
    nhsTen.scoreText = "${nhsTen.score}/3";
    lstNguHanhScore.add(nhsTen);

    totalScore = nhs.score + nhsCha.score + nhsMe.score + nhsTen.score;
    return lstNguHanhScore;
  }

  Future<List<NienMenh>> getListNienMenhForFamily(NguHanhInput nhi) async {
    List<NienMenh> lstNienMenh = [];
    NienMenh nienMenhDad = new NienMenh();
    nienMenhDad.who = "Cha";
    nienMenhDad.title = "Tuổi Cha";
    nienMenhDad.dateSolar = nhi.dadDateBorn;
    slc = SolarLunarConverter(
        year: nhi.dadDateBorn.year,
        month: nhi.dadDateBorn.month,
        day: nhi.dadDateBorn.day);
    nienMenhDad.dateLunar = slc.toLunar();
    await getCungMenh(nienMenhDad.dateSolar.year).then((value) {
      nienMenhDad.nienMenh = value;
    });
    nienMenhDad.menh = nienMenhDad.dateLunar.getMenh();
    lstNienMenh.add(nienMenhDad);

    NienMenh niemMenhMom = new NienMenh();
    niemMenhMom.who = "Mẹ";
    niemMenhMom.title = "Tuổi Mẹ";
    niemMenhMom.dateSolar = nhi.momDateBorn;
    slc = SolarLunarConverter(
        year: nhi.momDateBorn.year,
        month: nhi.momDateBorn.month,
        day: nhi.momDateBorn.day);
    niemMenhMom.dateLunar = slc.toLunar();
    await getCungMenh(niemMenhMom.dateSolar.year).then((value) {
      niemMenhMom.nienMenh = value;
    });
    niemMenhMom.menh = niemMenhMom.dateLunar.getMenh();
    lstNienMenh.add(niemMenhMom);

    NienMenh niemMenhKid = new NienMenh();
    niemMenhKid.who = "Con";
    niemMenhKid.title = "Tuổi Con";
    niemMenhKid.dateSolar = nhi.kidDateBorn;
    slc = SolarLunarConverter(
        year: nhi.kidDateBorn.year,
        month: nhi.kidDateBorn.month,
        day: nhi.kidDateBorn.day);
    niemMenhKid.dateLunar = slc.toLunar();
    await getCungMenh(niemMenhKid.dateSolar.year).then((value) {
      niemMenhKid.nienMenh = value;
    });
    niemMenhKid.menh = niemMenhKid.dateLunar.getMenh();
    lstNienMenh.add(niemMenhKid);
    return lstNienMenh;
  }

  Future<String> getCungMenh(int year) async {
    int mod = year % 60;
    CungMenh cm;
    await DBProvider.db.getCungMenhByMod(mod).then((CungMenh value) {
      cm = value;
    });
    return cm.name;
  }

  _onFavButtonPressed() {
    if (this.nhi.isFavorite == 1) {
      DBProvider.db.unsetFavoriteName(this.nhi).then((result) {
        if (result >= 0) {
          setState(() {
            this.nhi.isFavorite = 0;
            this.iconData = Icons.favorite_border;
          });
        }
      });
    } else {
      if (this.nhi.id == null) {
        var uuid = Uuid();
        setState(() {
          this.nhi.id = uuid.v1();
        });
      }
      DBProvider.db.setFavoriteName(this.nhi).then((result) {
        if (result >= 0) {
          setState(() {
            this.nhi.isFavorite = 1;
            this.iconData = Icons.favorite;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    nativeAdController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    var rng = new Random();
    var prob = rng.nextInt(100) / 100;
    if (_interstitialReady && prob <= interstitialProb){
      _interstitialAd.show();
    } else {
      Navigator.of(context).pop();
    }
    return Container() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (lstNienMenh == null || lstNguHanhScore == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(nguHanhDetailPageTitle),
            backgroundColor: Color(0xffB2210D),
          ),
          body: Container(
            color: Color(0xFFF9F3CC),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ));
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
              title: Text(nguHanhDetailPageTitle),
              backgroundColor: Color(0xffB2210D),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  var rng = new Random();
                  var prob = rng.nextInt(100) / 100;
                  if (_interstitialReady && prob <= interstitialProb){
                    _interstitialAd.show();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                        nhi != null
                            ? (nhi.isFavorite == 1
                                ? Icons.favorite
                                : Icons.favorite_border)
                            : Icons.favorite_border,
                        color: Colors.white),
                    onPressed: _onFavButtonPressed)
              ]),
          body: SingleChildScrollView(
              child: Container(
                  color: Color(0xFFF9F3CC),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                        child: Center(
                          child: Text(tongQuanTitle,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColorPrimary)),
                        ),
                      ),
                      _buildGeneralAnalysis(context),
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
                          child: Text(nguHanhTuoiTitle,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColorPrimary)),
                        ),
                      ),
                      _buildNienMenh(context),
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
                          child: Text(luanGiaiChiTietTitle,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColorPrimary)),
                        ),
                      ),
                      _buildNHScore(context)
                    ],
                  ))),
        ));
  }

  Widget _buildGeneralAnalysis(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder<TongQuan>(
          future: getGeneralAnalysis(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: buildHighlightTextInTheEnd(
                        context,
                        expectedNameTitle,
                        snapshot.data.expectedName,
                        primaryColor)),
                FutureBuilder(
                  future: _buildHighlighNames(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: snapshot.data,
                          ));
                    } else {
                      return CupertinoActivityIndicator();
                    }
                  },
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: buildHighlightTextInTheEnd(context, totalScoreTitle,
                        snapshot.data.score, Colors.red)),
                Align(
                    alignment: Alignment.topLeft,
                    child: buildHighlightTextInTheEnd(context, conclusionTitle,
                        snapshot.data.conclusion, Colors.black87)),
              ]);
            } else {
              return CupertinoActivityIndicator();
            }
          }),
    );
  }

  Future<List<Widget>> _buildHighlighNames(BuildContext context) async {
    var fullname = "${nhi.surname} ${nhi.firstname}";
    var names = fullname.trim().split(' ');
    List<Widget> lstNameWidgets = [];
    for (int i = 0; i < names.length; i++) {
      NguHanhTen nht;
      await DBProvider.db.getNguHanhTenByName(names[i]).then((value) {
        if (value != null) {
          nht = value;
        } else {
          nht = new NguHanhTen();
          nht.name = names[i];
          nht.type = undefined_type;
        }
      });
      lstNameWidgets.add(Align(
          alignment: Alignment.topLeft,
          child: buildHighlightNameText(
              context, "- Chữ ", names[i], " thuộc hành ", nht.type)));
    }
    return lstNameWidgets;
  }

  Future<List<Widget>> _buildListNameWidgets() async {
    List<Widget> lstNameWidgets = [];
    for (int i = 0; i < lstNHTNames.length - 1; i++) {
      lstNameWidgets.add(_buildNameAnalysis(
          context, lstNHTNames.elementAt(i), lstNHTNames.elementAt(i + 1)));
    }
    return lstNameWidgets;
  }

  Widget _buildNienMenh(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            children: lstNienMenh
                .map((data) => _buildNienMenhItem(context, data))
                .toList()));
  }

  Widget _buildNienMenhItem(BuildContext context, NienMenh nm) {
    if (nm != null) {
      return Card(
          elevation: 4,  // Change this
          shadowColor: Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Text(nm.title,
                    style:
                        TextStyle(height: 1.5, fontWeight: FontWeight.bold))),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "$solarDateTitle: ngày ${nm.dateSolar.day}, tháng ${nm.dateSolar.month}, năm ${nm.dateSolar.year}.",
                    style: TextStyle(height: 1.5))),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "$lunarDateTitle: ngày ${nm.dateLunar.getCanChiDay()}, tháng ${nm.dateLunar.getCanChiMonth()}, năm ${nm.dateLunar.getCanChiYear()}.",
                    style: TextStyle(height: 1.5))),
            Align(
                alignment: Alignment.topLeft,
                child: Text("$nienMenhTitle: ${nm.nienMenh}.",
                    style: TextStyle(height: 1.5))),
            Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text("$menhTitle: ", style: TextStyle(height: 1.5)),
                    highlightType(context, nm.menh)
                  ],
                ))
          ],
        ),
      ));
    } else {
      return CupertinoActivityIndicator();
    }
  }

  Widget _buildNHScore(BuildContext context) {
    final List fixedNHIs =
        Iterable<int>.generate(lstNguHanhScore.length - 1).toList();
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          ...fixedNHIs
              .map((idx) =>
                  _buildNHScoreItem(context, lstNguHanhScore.elementAt(idx)))
              .toList(),
          _buildNHScoreLastItem(context, lstNguHanhScore.last.title)
        ]));
  }

  Widget _buildNHScoreItem(BuildContext context, NguHanhScore nhs) {
    if (nhs != null) {
      return Card(
          elevation: 4,  // Change this
          shadowColor: Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(nhs.title,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Align(
                  alignment: Alignment.topLeft,
                  child: buildHighlightTextInTheEnd(context, nhs.content1Title,
                      nhs.content1, getColorByType(nhs.content1)),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: buildHighlightTextInTheEnd(context, nhs.content2Title,
                      nhs.content2, getColorByType(nhs.content2)),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("${nhs.content3Title}: ${nhs.content3}."),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: buildHighlightTextInTheEnd(
                      context, "$scoreTitle: ", nhs.scoreText, Colors.red),
                ),
              ],
            ),
      ));
    } else {
      return CupertinoActivityIndicator();
    }
  }

  Widget _buildNHScoreLastItem(BuildContext context, String title) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Text(lstNguHanhScore.last.title,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              FutureBuilder<List<Widget>>(
                future: _buildListNameWidgets(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data,
                    );
                  } else {
                    return CupertinoActivityIndicator();
                  }
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: buildHighlightTextInTheEnd(context, "$scoreTitle: ",
                    lstNguHanhScore.last.scoreText, Colors.red),
              )
            ],
      ),
    ));
  }

  Widget _buildNameAnalysis(
      BuildContext context, NguHanhTen nht1, NguHanhTen nht2) {
    int score = nhi.getScore(nht1, nht2);
    return buildHighlightNameRelationshipText(
        context,
        score,
        "Chữ ",
        nht1.name.trim(),
        " thuộc hành ",
        nht1.type,
        nht2.name != "" ? "với chữ " : "với tên con thuộc hành ",
        nht2.name != "" ? nht2.name.trim() : "",
        nht2.name != "" ? " thuộc hành " : "",
        nht2.type);
  }
}
