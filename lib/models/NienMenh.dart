import 'package:ngu_hanh_ten/utils/lunars.dart';

class NienMenh {
  String who;
  String title;
  DateTime dateSolar;
  LunarDate dateLunar;
  String nienMenh;
  String menh;

  NienMenh({
    this.who,
    this.title,
    this.dateSolar,
    this.dateLunar,
    this.nienMenh,
    this.menh
  });

  @override
  String toString() {
    return "$who: $title, $nienMenh, $menh";
  }
}