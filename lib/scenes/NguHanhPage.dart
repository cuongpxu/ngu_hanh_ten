import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/consts.dart';
import '../utils/colors.dart';
import '../utils/adsId.dart';
import '../utils/commons.dart';
import '../models/NguHanhInput.dart';
import 'NguHanhDetailPage.dart';
import 'InformationPage.dart';

class NguHanhPage extends StatefulWidget {
  @override
  _NguHanhPageState createState() => _NguHanhPageState();
}

enum Gender { male, female }

class _NguHanhPageState extends State<NguHanhPage> {
  double adsHeight = 60.0;
  BannerAd _ad;
  NguHanhInput nhInput;
  final timeFormatter = DateFormat("HH:mm");
  final dateFormatter = DateFormat("dd/MM/yyyy");
  final _formKey = GlobalKey<FormState>();
  final TextEditingController surnameTEC = TextEditingController();
  final TextEditingController firstnameTEC = TextEditingController();
  final TextEditingController kidDateBornTEC = TextEditingController();
  final TextEditingController dadDateBornTEC = TextEditingController();
  final TextEditingController momDateBornTEC = TextEditingController();

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
    nhInput = new NguHanhInput();
    // // Get user input from prefs
    _getUserInformation();

    surnameTEC.addListener(_setSurname);
    firstnameTEC.addListener(_setFirstName);
    kidDateBornTEC.addListener(_setKidDateBorn);
    dadDateBornTEC.addListener(_setDadDateBorn);
    momDateBornTEC.addListener(_setMomDateBorn);
  }

  _getUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.surnameTEC.text = (prefs.getString('surname') ?? '');
      this.firstnameTEC.text = (prefs.getString('firstname') ?? '');
      this.kidDateBornTEC.text = (prefs.getString('kidDateBorn') ?? '');
      this.dadDateBornTEC.text = (prefs.getString('dadDateBorn') ?? '');
      this.momDateBornTEC.text = (prefs.getString('momDateBorn') ?? '');
    });
  }

  _saveUserInformation(NguHanhInput nhi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('surname', nhi.surname);
    await prefs.setString('firstname', nhi.firstname);
    await prefs.setString('kidDateBorn', dateFormatter.format(nhi.kidDateBorn));
    await prefs.setString('dadDateBorn', dateFormatter.format(nhi.dadDateBorn));
    await prefs.setString('momDateBorn', dateFormatter.format(nhi.momDateBorn));
  }

  _setSurname() {
    setState(() {
      this.nhInput.surname = surnameTEC.text;
    });
  }

  _setFirstName() {
    setState(() {
      this.nhInput.firstname = firstnameTEC.text;
    });
  }

  _setKidDateBorn() {
    setState(() {
      if (kidDateBornTEC.text != '') {
        this.nhInput.kidDateBorn = dateFormatter.parse(kidDateBornTEC.text);
      }
    });
  }

  _setDadDateBorn() {
    setState(() {
      if (dadDateBornTEC.text != '') {
        this.nhInput.dadDateBorn = dateFormatter.parse(dadDateBornTEC.text);
      }
    });
  }

  _setMomDateBorn() {
    setState(() {
      if (momDateBornTEC.text != '') {
        this.nhInput.momDateBorn = dateFormatter.parse(momDateBornTEC.text);
      }
    });
  }

  @override
  void dispose() {
    surnameTEC.dispose();
    firstnameTEC.dispose();
    kidDateBornTEC.dispose();
    dadDateBornTEC.dispose();
    momDateBornTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
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
              margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(nguHanhPageTitle.toUpperCase(),
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'ThuPhap')),
                      IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          tooltip: 'Thông tin',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformationPage(),
                                ));
                          }),
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return surnameHint;
                  } else if (value.length < 2) {
                    return surnameError;
                  }
                  return null;
                },
                controller: surnameTEC,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: backgroundColor,
                  // hintText: surname,
                  labelText: surname,
                  labelStyle: new TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellowAccent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellowAccent),
                  ),
                  errorStyle: TextStyle(color: Colors.yellowAccent),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return firstnameHint;
                  } else if (value.length < 2) {
                    return firstnameError;
                  }
                  return null;
                },
                controller: firstnameTEC,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: firstname,
                  labelStyle: new TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellowAccent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellowAccent),
                  ),
                  errorStyle: TextStyle(color: Colors.yellowAccent),
                ),
              ),
            ),
            _buildDateBorn(context, kidDateBornTEC, kidYearBorn),
            _buildDateBorn(context, dadDateBornTEC, dadYearBorn),
            _buildDateBorn(context, momDateBornTEC, momYearBorn),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return secondColor;
                    return primaryColor; // Use the component's default.
                  },
                )),
                child: Text(checkNameTitle,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    NguHanhInput nhi = new NguHanhInput(
                        firstname:
                            firstnameTEC.text.capitalizeFirstofEach.trim(),
                        surname: surnameTEC.text.capitalizeFirstofEach.trim(),
                        kidDateBorn: dateFormatter.parse(kidDateBornTEC.text),
                        dadDateBorn: dateFormatter.parse(dadDateBornTEC.text),
                        momDateBorn: dateFormatter.parse(momDateBornTEC.text),
                        isFavorite: 0);

                    if (nhi.kidDateBorn.year <= nhi.dadDateBorn.year ||
                        nhi.kidDateBorn.year <= nhi.dadDateBorn.year) {
                      showAlertDialog(context);
                    } else {
                      _saveUserInformation(nhi);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NguHanhDetailPage(nhi: nhi),
                          ));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildDateBorn(BuildContext context,
      TextEditingController dateController, String label) {
    DateTime next10Years = new DateTime(DateTime.now().year + 10);
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: DateTimeField(
          validator: (DateTime dateTime) {
            if (dateController.text != '') {
              dateTime = dateFormatter.parse(dateController.text);
            }
            if (dateTime == null) {
              return dateBornHint;
            }
            return null;
          },
          controller: dateController,
          format: dateFormatter,
          resetIcon: null,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: next10Years);
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: new TextStyle(color: Colors.white),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellowAccent),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellowAccent),
            ),
            errorStyle: TextStyle(color: Colors.yellowAccent),
            prefixIcon: Icon(Icons.calendar_today_sharp, color: Colors.white),
          ),
        ));
  }
}
