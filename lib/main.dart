import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'databases/localDB.dart';
import 'utils/consts.dart';
import 'scenes/NguHanhPage.dart';
import 'scenes/GoiYPage.dart';
import 'scenes/TenHayPage.dart';
import 'scenes/FavoriteNamePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  await DBProvider.db.initDB();
  runApp(
      MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
          Locale('en', 'US')
        ],
        title: appTitle,
        home: new MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  double adsHeight = 0;
  final nativeAdController = NativeAdmobController();
  StreamSubscription _subscription;
  ImageProvider bg;

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    NguHanhPage(),
    GoiYPage(),
    TenHayPage(),
    FavoriteNamePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          this.adsHeight = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          this.adsHeight = 90;
        });
        break;

      default:
        break;
    }
  }

  @override
  void didChangeDependencies() async {
    bg = AssetImage("assets/bg.png");
    await precacheImage(bg, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          body: Stack(
            children: [
              Image(
                image: this.bg,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              _widgetOptions.elementAt(_selectedIndex),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded), label: checkNameTitle),
              BottomNavigationBarItem(
                icon: Icon(Icons.recommend),
                label: suggestTitle,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: findTitle,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: favoriteTitle,
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xffB2210D),
            onTap: _onItemTapped,
          ),
        ));
  }
}
