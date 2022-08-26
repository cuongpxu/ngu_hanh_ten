import 'package:flutter/material.dart';
import 'consts.dart';
import 'colors.dart';

Widget buildHighlightNameRelationshipText(
    BuildContext context,
    int score,
    String s1,
    String t1,
    String s2,
    String h1,
    String s3,
    String t2,
    String s4,
    String h2) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    textAlign: TextAlign.justify,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(text: s1),
        new TextSpan(
            text: t1,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(t1))),
        new TextSpan(text: s2),
        new TextSpan(
            text: h1,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(h1))),
        (score == 0)
            ? new TextSpan(text: " $tuong_khac ")
            : (score == 1)
                ? new TextSpan(text: " $not_sinh_khac ")
                : new TextSpan(text: " $tuong_sinh "),
        new TextSpan(text: s3),
        new TextSpan(
            text: t2,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(t2))),
        new TextSpan(text: s4),
        new TextSpan(
            text: h2,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(h2))),
        new TextSpan(text: ".")
      ],
    ),
  );
}

Widget buildHighlightNameText(
    BuildContext context, String s1, String h1, String s2, String h2) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    textAlign: TextAlign.justify,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(text: s1),
        new TextSpan(
            text: h1,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(s1))),
        new TextSpan(text: s2),
        new TextSpan(
            text: h2,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(h2))),
        new TextSpan(text: ".")
      ],
    ),
  );
}

Widget buildHighlightInRelationshipWithParentText(BuildContext context,
    int score, String s1, String h1, String s2, String h2) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    textAlign: TextAlign.justify,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: textColorPrimary),
      children: <TextSpan>[
        new TextSpan(text: s1),
        new TextSpan(
            text: h1,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(h1))),
        (score == 0)
            ? new TextSpan(text: " $tuong_khac ")
            : (score == 1)
                ? new TextSpan(text: " $not_sinh_khac ")
                : new TextSpan(text: " $tuong_sinh "),
        new TextSpan(text: s2),
        new TextSpan(
            text: h2,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: getColorByType(h2))),
        (score == 0)
            ? new TextSpan(text: ", $kl_xau.")
            : (score == 1)
                ? new TextSpan(text: ", $kl_trung_binh.")
                : new TextSpan(text: ", $kl_tot."),
      ],
    ),
  );
}

Widget buildHighlightTextAtStart(
    BuildContext context, String s1, String s2, Color c) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(
            text: s1,
            style: new TextStyle(fontWeight: FontWeight.bold, color: c)),
        new TextSpan(text: s2),
        new TextSpan(text: "."),
      ],
    ),
  );
}

Widget buildHighlightTextInMiddle(
    BuildContext context, String s1, String s2, String s3, Color c) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(text: s1),
        new TextSpan(
            text: s2,
            style: new TextStyle(fontWeight: FontWeight.bold, color: c)),
        new TextSpan(text: s3),
      ],
    ),
  );
}

Widget buildHighlightTextInTheEnd(
    BuildContext context, String s1, String s2, Color c) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(text: s1),
        new TextSpan(
            text: s2,
            style: new TextStyle(fontWeight: FontWeight.bold, color: c)),
        new TextSpan(text: "."),
      ],
    ),
  );
}

Widget buildHighlightConclusion(
    BuildContext context, String s1, String s2, String s3, Color c) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(height: 1.5, fontSize: 14, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(
            text: s1, style: new TextStyle(fontWeight: FontWeight.bold)),
        new TextSpan(text: s2),
        new TextSpan(
            text: s3,
            style: new TextStyle(fontWeight: FontWeight.bold, color: c)),
        new TextSpan(text: '.'),
      ],
    ),
  );
}

Widget buildHighlightTitle(
    BuildContext context, String s1, String s2, Color c) {
  return RichText(
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(
          height: 1.5,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold),
      children: <TextSpan>[
        new TextSpan(text: s1),
        new TextSpan(text: s2, style: new TextStyle(color: c)),
        new TextSpan(text: ":"),
      ],
    ),
  );
}

Widget highlightType(BuildContext context, String type) {
  switch (type) {
    case KIM:
      return Text(type,
          style: TextStyle(
              height: 1.5,
              color: Color(0xFFDF8602),
              fontWeight: FontWeight.bold));
    case MOC:
      return Text(type,
          style: TextStyle(
              height: 1.5,
              color: Color(0xFF008D36),
              fontWeight: FontWeight.bold));
    case THUY:
      return Text(type,
          style: TextStyle(
              height: 1.5,
              color: Color(0xFF1D70B7),
              fontWeight: FontWeight.bold));
    case HOA:
      return Text(type,
          style: TextStyle(
              height: 1.5,
              color: Color(0xFFE20613),
              fontWeight: FontWeight.bold));
    case THO:
      return Text(type,
          style: TextStyle(
              height: 1.5,
              color: Color(0xFF683B11),
              fontWeight: FontWeight.bold));
    default:
      return Text(type,
          style: TextStyle(
              height: 1.5, color: Colors.black, fontWeight: FontWeight.bold));
  }
}

Color getColorByType(String type) {
  switch (type) {
    case KIM:
      return Color(0xFFDF8602);
    case MOC:
      return Color(0xFF008D36);
    case THUY:
      return Color(0xFF1D70B7);
    case HOA:
      return Color(0xFFE20613);
    case THO:
      return Color(0xFF683B11);
    case ALL:
      return Colors.black;
    default:
      return textColorPrimary;
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thông tin không chính xác"),
    content: Text("Năm sinh của con không được nhỏ hơn của cha, mẹ!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach => this
      .split(" ")
      .map(
          (word) => '${word.substring(0, 1).toUpperCase()}${word.substring(1)}')
      .join(" ");
}
