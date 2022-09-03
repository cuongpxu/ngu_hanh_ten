import 'dart:async';
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
import 'NguHanhPage.dart';
import 'GoiYDetailPage.dart';

class GoiYPage extends StatefulWidget {
  @override
  _GoiYPageState createState() => _GoiYPageState();
}

class _GoiYPageState extends State<GoiYPage> {
  double adsHeight = 90.0;
  BannerAd _ad;
  NguHanhInput nhInput;
  final dateFormatter = DateFormat("dd/MM/yyyy");
  final _formKey = GlobalKey<FormState>();
  final TextEditingController surnameTEC = TextEditingController();
  final TextEditingController kidDateBornTEC = TextEditingController();
  final TextEditingController dadDateBornTEC = TextEditingController();
  final TextEditingController momDateBornTEC = TextEditingController();

  Gender _gender = Gender.male;

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

    // Get user input from prefs
    _getUserInformation();

    surnameTEC.addListener(_setSurname);
    kidDateBornTEC.addListener(_setKidDateBorn);
    dadDateBornTEC.addListener(_setDadDateBorn);
    momDateBornTEC.addListener(_setMomDateBorn);
  }

  _getUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.surnameTEC.text = (prefs.getString('surname') ?? '');
      this.kidDateBornTEC.text = (prefs.getString('kidDateBorn') ?? '');
      this.dadDateBornTEC.text = (prefs.getString('dadDateBorn') ?? '');
      this.momDateBornTEC.text = (prefs.getString('momDateBorn') ?? '');
    });
  }

  _setSurname() {
    setState(() {
      this.nhInput.surname = surnameTEC.text.capitalizeFirstofEach;
    });
  }

  _setKidDateBorn() {
    setState(() {
      if (kidDateBornTEC.text != ''){
        this.nhInput.kidDateBorn = dateFormatter.parse(kidDateBornTEC.text);
      }
    });
  }

  _setDadDateBorn() {
    setState(() {
      if (dadDateBornTEC.text != ''){
        this.nhInput.dadDateBorn = dateFormatter.parse(dadDateBornTEC.text);
      }
    });
  }

  _setMomDateBorn() {
    setState(() {
      if (momDateBornTEC.text != ''){
        this.nhInput.momDateBorn = dateFormatter.parse(momDateBornTEC.text);
      }
    });
  }

  @override
  void dispose() {
    surnameTEC.dispose();
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
                width: _ad.size.width.toDouble(),
                height: adsHeight,
                alignment: Alignment.center,
                child: AdWidget(ad: _ad),
              ),
              Container(
                margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                child: Center(
                  child: Text(goiyPageTitle.toUpperCase(),
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
                  controller: surnameTEC,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: surname,
                      labelStyle: new TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellowAccent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellowAccent),
                      ),
                      errorStyle: TextStyle(color: Colors.yellowAccent),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return surnameHint;
                    } else if (value.length < 2) {
                      return surnameError;
                    }
                    return null;
                  }
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child:
                          Text(gender, style: TextStyle(color: Colors.white))),
                  Expanded(
                      flex: 2,
                      child: ListTile(
                        title: const Text(male,
                            style: TextStyle(color: Colors.white)),
                        leading: Radio(
                          activeColor: Colors.white,
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (Gender value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: ListTile(
                        title:
                            Text(female, style: TextStyle(color: Colors.white)),
                        leading: Radio(
                          activeColor: Colors.white,
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (Gender value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                      )),
                ],
              ),
              _buildHourDateBorn(context, kidDateBornTEC, kidYearBorn),
              _buildHourDateBorn(context, dadDateBornTEC, dadYearBorn),
              _buildHourDateBorn(context, momDateBornTEC, momYearBorn),
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
                  child: Text(suggestButton,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      NguHanhInput nhi = new NguHanhInput(
                          surname: surnameTEC.text.capitalizeFirstofEach,
                          gender: _gender,
                          kidDateBorn: dateFormatter.parse(kidDateBornTEC.text),
                          dadDateBorn: dateFormatter.parse(dadDateBornTEC.text),
                          momDateBorn:
                              dateFormatter.parse(momDateBornTEC.text));

                      if (nhi.kidDateBorn.year <= nhi.dadDateBorn.year ||
                          nhi.kidDateBorn.year <= nhi.dadDateBorn.year) {
                        showAlertDialog(context);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoiYDetailPage(nhi: nhi),
                            ));
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHourDateBorn(BuildContext context,
      TextEditingController dateController, String label) {
    DateTime next10Years = new DateTime(DateTime.now().year + 10);
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: DateTimeField(
          validator: (DateTime dateTime) {
            if (dateController.text != ''){
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
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
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
            prefixIcon: Icon(
              Icons.calendar_today_sharp,
              color: Colors.white,
            ),
          ),
        ));
  }
}
