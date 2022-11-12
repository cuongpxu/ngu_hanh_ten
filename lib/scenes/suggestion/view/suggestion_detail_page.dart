import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../databases/local_db.dart';
import '../../../models/NguHanhInput.dart';
import '../../../models/TongQuan.dart';
import '../../../models/NguHanhScore.dart';
import '../../../models/NguHanhTen.dart';
import '../../../models/NienMenh.dart';
import '../../../models/CungMenh.dart';
import '../../../utils/colors.dart';
import '../../../utils/consts.dart';
import '../../../utils/lunars.dart';
import '../../../utils/commons.dart';
import '../../../utils/adsId.dart';
import '../../detail/view/ngu_hanh_detail_page.dart';
import '../../detail/view/ngu_hanh_page.dart';

class GoiYDetailPage extends StatefulWidget {
  final NguHanhInput nhi;

  GoiYDetailPage({this.nhi});

  @override
  _GoiYDetailPageState createState() => _GoiYDetailPageState(nhi: this.nhi);
}

class _GoiYDetailPageState extends State<GoiYDetailPage> {
  double adsHeight = 60.0;
  NguHanhInput nhi;
  SolarLunarConverter slc;
  int totalScore;
  TongQuan tq;
  List<NguHanhScore> lstNguHanhScore;
  List<NienMenh> lstNienMenh;
  List<NguHanhTen> lstNHTSurnames;
  List<NguHanhInput> lstSuggestedNames;
  ImageProvider bg;

  int scoreTS1 = 0;
  int scoreTS2 = 0;
  int scoreTS3 = 0;
  String suggestedNameType = "Kim";
  String suggestedMidNameType = "Kim";

  InterstitialAd _interstitialAd;
  BannerAd _ad;
  bool _interstitialReady;

  _GoiYDetailPageState({this.nhi});

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
    getData();
    getSurnames();
    createInterstitialAd();
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

  getData() async {
    await getListNienMenhForFamily(this.nhi).then((List<NienMenh> lst) {
      setState(() {
        lstNienMenh = lst;
      });
    });
  }

  getSurnames() async {
    var surnames = nhi.surname.trim().split(' ');
    List<NguHanhTen> nhtSurnames = [];
    for (int i = 0; i < surnames.length; i++) {
      NguHanhTen nht = await DBProvider.db.getNguHanhTenByName(surnames[i]);
      if (nht == null) {
        nht = new NguHanhTen(nameId: '');
        nht.name = surnames[i];
        nht.type = undefined_type;
      }
      nhtSurnames.add(nht);
    }

    setState(() {
      this.lstNHTSurnames = nhtSurnames;
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    bg = AssetImage('assets/bg.png');
    await precacheImage(bg, context);
    super.didChangeDependencies();
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
    if (lstNienMenh == null) {
      return Scaffold(
          appBar: AppBar(
              title: Text(nguHanhDetailPageTitle),
              backgroundColor: primaryColor),
          body: Stack(
            children: [
              Image(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                image: this.bg,
                fit: BoxFit.cover,
              ),
              Container(
                color:  Color(0xFFF9F3CC),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            ],
          ));
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
              title: Text(goiyDetailPageTitle), backgroundColor: Color(0xffB2210D)),
          body: Stack(
            children: [
              SingleChildScrollView(
                  child: Container(
                      color:  Color(0xFFF9F3CC),
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
                          _buildNHTuongSinh(context),
                          _buildRelationshipWithParent1(context),
                          _buildRelationshipWithParent2(context),
                          _buildRelationshipWithKid(context),
                          Container(
                              margin: EdgeInsets.all(10.0),
                              child: _buildConclusion(context)),
                          _buildNameAnalysis(context),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: adsHeight,
                            alignment: Alignment.center,
                            child: _ad == null ? Container() : AdWidget(ad: _ad),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(listSuggestedNameTitle,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textColorPrimary)),
                                IconButton(
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Xem thêm',
                                  onPressed: () async {
                                    List<NguHanhTen> lstMidNames =
                                        await DBProvider.db
                                            .get10SuggestedNamesByType(
                                                suggestedMidNameType);
                                    List<NguHanhTen> lstNames = await DBProvider
                                        .db
                                        .get10SuggestedNamesByType(
                                            suggestedNameType);

                                    List<NguHanhInput> nhis = [];
                                    var rgn = new Random();
                                    String midName = '';
                                    if (nhi.gender == Gender.male){
                                      if (suggestedMidNameType == THO){
                                        midName = "Văn";
                                      }
                                    } else {
                                      if (suggestedMidNameType == MOC){
                                        midName = "Thị";
                                      }
                                    }

                                    for (int i = 0; i < lstMidNames.length; i++) {
                                      NguHanhInput suggestedNHI =
                                          new NguHanhInput(
                                        firstname: (rgn.nextInt(20) % 3 == 0 && midName != '') ? "$midName ${lstNames.elementAt(i).name}"
                                            : "${lstMidNames.elementAt(i).name} ${lstNames.elementAt(i).name}",
                                        surname: nhi.surname,
                                        kidDateBorn: nhi.kidDateBorn,
                                        dadDateBorn: nhi.dadDateBorn,
                                        momDateBorn: nhi.momDateBorn,
                                      );
                                      nhis.add(suggestedNHI);
                                    }
                                    setState(() {
                                      this.lstSuggestedNames = nhis;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Center(
                                child: Text(listSuggestedNameDisclaimerTitle,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    textAlign: TextAlign.justify)),
                          ),
                          _buildSuggestedNames(context)
                        ],
                      )))
            ],
          )
        )
    );
  }

  Widget _buildNameAnalysis(BuildContext context) {
    var surnames = nhi.surname.trim().split(' ');

    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(children: [
          buildHighlightTextInMiddle(
              context,
              "Do chọn tên con thuộc hành ",
              suggestedNameType,
              ", ta cần xem xét ngũ hành tương quan trong Họ, tên đệm và tên con, cụ thể như sau:",
              getColorByType(suggestedNameType)),
          surnames.length == 1
              ? _buildSurnameAnalysis(context, lstNHTSurnames.first,
                  new NguHanhTen(name: "", type: suggestedNameType))
              : FutureBuilder<List<Widget>>(
                  future: _buildListNameWidgets(surnames),
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
          _buildSuggestedMidName(context)
        ]));
  }

  Widget _buildNHTuongSinh(BuildContext context) {
    NguHanhTen nhtCon = new NguHanhTen(type: lstNienMenh.last.menh);
    List<String> nhTuongSinh = nhtCon.getNguHanhTuongSinh();
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textAlign: TextAlign.justify,
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style:
                  new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
              children: <TextSpan>[
                new TextSpan(text: "- Con có mệnh "),
                new TextSpan(
                    text: nhtCon.type,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColorByType(nhtCon.type))),
                new TextSpan(text: " tương sinh với các tên có hành "),
                new TextSpan(
                    text: nhTuongSinh.first,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColorByType(nhTuongSinh.first))),
                new TextSpan(text: " và "),
                new TextSpan(
                    text: nhTuongSinh.last,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColorByType(nhTuongSinh.last))),
                new TextSpan(text: " hoặc có thể chọn tên thuộc hành "),
                new TextSpan(
                    text: nhtCon.type,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColorByType(nhtCon.type))),
                new TextSpan(text: " cùng bản mệnh với con."),
              ],
            ),
          ),
        ));
  }

  Widget _buildRelationshipWithParent1(BuildContext context) {
    NguHanhTen nhtCon = new NguHanhTen(type: lstNienMenh.last.menh);
    List<String> nhTuongSinh = nhtCon.getNguHanhTuongSinh();
    String banMenhCha = lstNienMenh.first.menh;
    String banMenhMe = lstNienMenh.elementAt(1).menh;
    int scoreCha = nhi.getScore(new NguHanhTen(type: nhTuongSinh.first),
        new NguHanhTen(type: banMenhCha));
    int scoreMe = nhi.getScore(new NguHanhTen(type: nhTuongSinh.first),
        new NguHanhTen(type: banMenhMe));
    setState(() {
      scoreTS1 = scoreCha + scoreMe;
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: buildHighlightTitle(
                  context,
                  "Nếu chọn tên con thuộc hành ",
                  nhTuongSinh.first,
                  getColorByType(nhTuongSinh.first))),
          buildHighlightInRelationshipWithParentText(
              context,
              scoreCha,
              "- Hành của tên con là ",
              nhTuongSinh.first,
              "với Hành của bản mệnh cha là ",
              banMenhCha),
          buildHighlightInRelationshipWithParentText(
              context,
              scoreMe,
              "- Hành của tên con là ",
              nhTuongSinh.first,
              "với Hành của bản mệnh mẹ là ",
              banMenhMe)
        ],
      ),
    );
  }

  Widget _buildRelationshipWithParent2(BuildContext context) {
    NguHanhTen nhtCon = new NguHanhTen(type: lstNienMenh.last.menh);
    List<String> nhTuongSinh = nhtCon.getNguHanhTuongSinh();
    String banMenhCha = lstNienMenh.first.menh;
    String banMenhMe = lstNienMenh.elementAt(1).menh;
    int scoreCha = nhi.getScore(new NguHanhTen(type: nhTuongSinh.last),
        new NguHanhTen(type: banMenhCha));
    int scoreMe = nhi.getScore(new NguHanhTen(type: nhTuongSinh.last),
        new NguHanhTen(type: banMenhMe));

    setState(() {
      scoreTS2 = scoreCha + scoreMe;
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: buildHighlightTitle(
                  context,
                  "Nếu chọn tên con thuộc hành ",
                  nhTuongSinh.last,
                  getColorByType(nhTuongSinh.last))),
          buildHighlightInRelationshipWithParentText(
              context,
              scoreCha,
              "- Hành của tên con là ",
              nhTuongSinh.last,
              "với Hành của bản mệnh cha là ",
              banMenhCha),
          buildHighlightInRelationshipWithParentText(
              context,
              scoreMe,
              "- Hành của tên con là ",
              nhTuongSinh.last,
              "với Hành của bản mệnh mẹ là ",
              banMenhMe)
        ],
      ),
    );
  }

  Widget _buildRelationshipWithKid(BuildContext context) {
    NguHanhTen nhtCon = new NguHanhTen(type: lstNienMenh.last.menh);
    String banMenhCha = lstNienMenh.first.menh;
    String banMenhMe = lstNienMenh.elementAt(1).menh;
    int scoreCha = nhi.getScore(nhtCon, new NguHanhTen(type: banMenhCha));
    int scoreMe = nhi.getScore(nhtCon, new NguHanhTen(type: banMenhMe));

    setState(() {
      scoreTS3 = scoreCha + scoreMe;
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: buildHighlightTitle(
                  context,
                  "Nếu chọn tên con thuộc hành ",
                  nhtCon.type,
                  getColorByType(nhtCon.type))),
          buildHighlightInRelationshipWithParentText(
              context,
              scoreCha,
              "- Hành của tên con là ",
              nhtCon.type,
              "với Hành của bản mệnh cha là ",
              banMenhCha),
          buildHighlightInRelationshipWithParentText(
              context,
              scoreMe,
              "- Hành của tên con là ",
              nhtCon.type,
              "với Hành của bản mệnh mẹ là ",
              banMenhMe),
        ],
      ),
    );
  }

  Widget _buildConclusion(BuildContext context) {
    NguHanhTen nhtCon = new NguHanhTen(type: lstNienMenh.last.menh);
    List<String> nhTuongSinh = nhtCon.getNguHanhTuongSinh();

    if (scoreTS1 >= scoreTS2) {
      if (scoreTS1 >= scoreTS3) {
        // KL: tuong sinh 1
        setState(() {
          suggestedNameType = nhTuongSinh.first;
        });
        return Align(
          alignment: Alignment.topLeft,
          child: buildHighlightConclusion(
              context,
              "Kết luận: ",
              "Bạn nên đặt tên con theo hành ",
              nhTuongSinh.first,
              getColorByType(nhTuongSinh.first)),
        );
      } else {
        // KL: tuong sinh 3
        setState(() {
          suggestedNameType = nhtCon.type;
        });
        return Align(
          alignment: Alignment.topLeft,
          child: buildHighlightConclusion(
              context,
              "Kết luận: ",
              "Bạn nên đặt tên con theo hành ",
              nhtCon.type,
              getColorByType(nhtCon.type)),
        );
      }
    } else {
      if (scoreTS2 >= scoreTS3) {
        // KL: tuong sinh 2
        setState(() {
          suggestedNameType = nhTuongSinh.last;
        });
        return Align(
          alignment: Alignment.topLeft,
          child: buildHighlightConclusion(
              context,
              "Kết luận: ",
              "Bạn nên đặt tên con theo hành ",
              nhTuongSinh.last,
              getColorByType(nhTuongSinh.last)),
        );
      } else {
        // KL: tuong sinh 3
        setState(() {
          suggestedNameType = nhtCon.type;
        });
        return Align(
          alignment: Alignment.topLeft,
          child: buildHighlightConclusion(
              context,
              "Kết luận: ",
              "Bạn nên đặt tên con theo hành ",
              nhtCon.type,
              getColorByType(nhtCon.type)),
        );
      }
    }
  }

  Future<List<Widget>> _buildListNameWidgets(List<String> surnames) async {
    List<Widget> lstSurnames = [];
    for (int i = 0; i < lstNHTSurnames.length - 1; i++) {
      lstSurnames.add(_buildSurnameAnalysis(context,
          lstNHTSurnames.elementAt(i), lstNHTSurnames.elementAt(i + 1)));
    }

    lstSurnames.add(_buildSurnameAnalysis(context, lstNHTSurnames.last,
        new NguHanhTen(name: "", type: suggestedNameType)));
    return lstSurnames;
  }

  Widget _buildSurnameAnalysis(
      BuildContext context, NguHanhTen nht1, NguHanhTen nht2) {
    int score = nhi.getScore(nht1, nht2);
    return buildHighlightNameRelationshipText(
        context,
        score,
        "- Chữ ",
        nht1.name.trim(),
        " thuộc hành ",
        nht1.type,
        nht2.name != "" ? "với chữ " : "với tên con thuộc hành ",
        nht2.name != "" ? nht2.name.trim() : "",
        nht2.name != "" ? " thuộc hành " : "",
        nht2.type);
  }

  Widget _buildSuggestedMidName(BuildContext context) {

    NguHanhTen nht = lstNHTSurnames.last;
    List<String> nhTuongSinh = nht.getNguHanhTuongSinh();
    setState(() {
      if (nhTuongSinh.length != 0) {
        suggestedMidNameType = nhTuongSinh.first;
      }
    });

    return buildHighlightTextInTheEnd(
        context,
        "- Sẽ tốt hơn nếu bạn chọn tên đệm cho con thuộc hành ",
        suggestedMidNameType,
        getColorByType(suggestedMidNameType));
  }

  Widget _buildSuggestedNames(BuildContext context) {
    var rgn = new Random();
    if (lstSuggestedNames != null) {
      final List fixedNHIs =
          Iterable<int>.generate(this.lstSuggestedNames.length).toList();
      return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ...fixedNHIs.map((idx) {
                  return Card(
                      child: new InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NguHanhDetailPage(
                                nhi: this.lstSuggestedNames.elementAt(idx)),
                          ));
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            "${this.lstSuggestedNames[idx].surname} ${this.lstSuggestedNames[idx].firstname}",
                            style: TextStyle(
                                height: 1.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ));
                }).toList()
              ],
            ),
          ));
    }

    String midName = '';
    if (nhi.gender == Gender.male){
      if (suggestedMidNameType == THO){
        midName = "Văn";
      }
    } else {
      if (suggestedMidNameType == MOC){
        midName = "Thị";
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder(
        future: Future.wait([
          DBProvider.db.get10SuggestedNamesByType(suggestedMidNameType),
          DBProvider.db.get10SuggestedNamesByType(suggestedNameType),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NguHanhInput> nhis = [];
            for (int i = 0; i < snapshot.data[0].length; i++) {
              NguHanhInput suggestedNHI = new NguHanhInput(
                firstname: (rgn.nextInt(20) % 3 == 0 && midName != '') ? "$midName ${snapshot.data[1][i].name}"
                    : "${snapshot.data[0][i].name} ${snapshot.data[1][i].name}",
                surname: nhi.surname,
                gender: nhi.gender,
                kidDateBorn: nhi.kidDateBorn,
                dadDateBorn: nhi.dadDateBorn,
                momDateBorn: nhi.momDateBorn,
              );
              nhis.add(suggestedNHI);
            }

            final List fixedNHIs = Iterable<int>.generate(nhis.length).toList();

            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ...fixedNHIs.map((idx) {
                    return Card(
                        child: new InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NguHanhDetailPage(nhi: nhis.elementAt(idx)),
                            ));
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              "${nhis[idx].surname} ${nhis[idx].firstname}",
                              style: TextStyle(
                                  height: 1.5, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ));
                  }).toList()
                ],
              ),
            );
          } else {
            return CupertinoActivityIndicator();
          }
        },
      ),
    );
  }
}
