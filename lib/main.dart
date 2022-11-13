import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ngu_hanh_ten/scenes/suggestion/view/suggestion_page.dart';
import 'package:ngu_hanh_ten/scenes/detail/view/ngu_hanh_page.dart';
import 'package:ngu_hanh_ten/scenes/search/view/search_name_page.dart';
import 'package:ngu_hanh_ten/scenes/favorite/view/favorite_page.dart';
import 'package:ngu_hanh_ten/databases/local_db.dart';
import 'package:ngu_hanh_ten/utils/consts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  double adsHeight = 60.0;
  ImageProvider bg;

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    NameAnalyticPage(),
    SuggestionPage(),
    SearchNamePage(),
    FavoriteNamePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
