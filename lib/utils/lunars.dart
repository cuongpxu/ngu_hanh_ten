import 'consts.dart';

class LunarDate {
  final int year;
  final int month;
  final int day;
  final int leapMonth;
  final bool isLeapYear;

  static const CAN_NAME = ["Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý"];
  static const CHI_NAME = ["Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi"];

  /// Constructs a [LunarDate] instance.
  LunarDate(this.year, this.month, this.day, [this.isLeapYear = false, this.leapMonth = 0]);

  /// Returns [DateTime] with date in Lunar.
  DateTime toDate() => DateTime(this.year, this.month, this.day);

  jdFromDateAndHour(int dd, int mm, int yy, int hour){
    int jd = jdFromDate(dd, mm, yy);
    if (hour >= 23){
      jd = jd + 1;
    }
    return jd;
  }

  jdFromDate(int dd, int mm, int yy) {
    int a = (14 - mm) ~/ 12;
    int y = yy+4800-a;
    int m = mm+12*a-3;
    int jd = dd + (153*m+2)~/5 + 365*y + y~/4 - y~/100 + y~/400 - 32045;
    if (jd < 2299161) {
      jd = dd + (153*m+2)~/5 + 365*y + y~/4 - 32083;
    }
    //jd = jd - 1721425;
    return jd;
  }

  String getCanChiYear(){
    int can = (year + 6) % 10;
    int chi = (year + 8) % 12;
    return "${CAN_NAME[can]} ${CHI_NAME[chi]}";
  }

  String getMenh(){
    int can = (year + 6) % 10;
    int chi = (year + 8) % 12;

    int chiScore = 0;
    if ([0,1,6,7].contains(chi)){
      chiScore = 0;
    } else if ([2,3,8,9].contains(chi)){
      chiScore = 1;
    } else if ([4,5,10,11].contains(chi)){
      chiScore = 2;
    }

    int canScore = 0;
    if ([0,1].contains(can)){
      canScore = 1;
    } else if ([2,3].contains(can)){
      canScore = 2;
    } else if ([4,5].contains(can)){
      canScore = 3;
    } else if ([6,7].contains(can)){
      canScore = 4;
    } else if ([8,9].contains(can)){
      canScore = 5;
    }

    int total = canScore + chiScore;
    total = total > 5 ? total - 5: total;
    if (total == 1)
      return NGU_HANH[0];
    else if (total == 2)
      return NGU_HANH[2];
    else if (total == 3)
      return NGU_HANH[3];
    else if (total == 4)
      return NGU_HANH[4];
    else
      return NGU_HANH[1];
  }

  String getCanChiMonth(){
    int can = (year * 12 + month + 3) % 10;
    int chi = month >= 11 ? month % 11 : month + 1;
    return "${CAN_NAME[can]} ${CHI_NAME[chi]}";
  }

  String getCanChiDay(){
    int jd = jdFromDate(day, month, year);
    int can = (jd + 9 ) % 10;
    int chi = (jd + 1) % 12;
    return "${CAN_NAME[can]} ${CHI_NAME[chi]}";
  }

  String getCanChiHour(int hour){
    int jd = jdFromDate(day, month, year);
    print(jd);
    return "${getCanHour(jd, hour)} ${getChiHour(hour)}";
  }

  int getChiHourIdx(String chiName){
    int idx = 0;
    for (int i = 0 ; i < CHI_NAME.length; i++){
      if (chiName == CHI_NAME[i]){
        idx = i;
        break;
      }
    }
    return idx;
  }

  String getCanHour(int jd, int hour){
    String canHour = "";
    int canDay = (jd + 9 ) % 10;
    String canNgay = CAN_NAME[canDay];
    List<String> arrCanHour = ["Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất"];
    if (canNgay == CAN_NAME[0] || canNgay == CAN_NAME[5]){
      arrCanHour = ["Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất"];
    }
    if (canNgay == CAN_NAME[1] || canNgay == CAN_NAME[6]){
      arrCanHour = ["Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh"];
    }
    if (canNgay == CAN_NAME[2] || canNgay == CAN_NAME[7]){
      arrCanHour = ["Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ"];
    }
    if (canNgay == CAN_NAME[3] || canNgay == CAN_NAME[8]){
      arrCanHour = ["Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ","Canh", "Tân"];
    }
    if (canNgay == CAN_NAME[4] || canNgay == CAN_NAME[9]){
      arrCanHour = ["Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh", "Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất"];
    }
    int chiIdx = getChiHourIdx(getChiHour(hour));
    canHour = arrCanHour[chiIdx];
    return canHour;
  }

  String getChiHour(int hour){
    int chi = 0;
    if (hour >= 23 || hour < 1){
      chi = 0;
    } else if (hour >= 1 && hour < 3) {
      chi = 1;
    } else if (hour >= 3 && hour < 5) {
      chi = 2;
    } else if (hour >= 5 && hour < 7) {
      chi = 3;
    } else if (hour >= 7 && hour < 9) {
      chi = 4;
    } else if (hour >= 9 && hour < 11) {
      chi = 5;
    } else if (hour >= 11 && hour < 13) {
      chi = 6;
    } else if (hour >= 13 && hour < 15) {
      chi = 7;
    } else if (hour >= 15 && hour < 17) {
      chi = 8;
    } else if (hour >= 17 && hour < 19) {
      chi = 9;
    } else if (hour >= 19 && hour < 21) {
      chi = 10;
    } else if (hour >= 21 && hour < 23) {
      chi = 11;
    }
    return CHI_NAME[chi];
  }
}

class SolarLunarConverter {
  final int year;
  final int month;
  final int day;
  static const List<int> LUNAR_MONTH_DAYS = [
    1887, 0x1694, 0x16aa, 0x4ad5, 0xab6, 0xc4b7, 0x4ae, 0xa56, 0xb52a, 0x1d2a, 0xd54, 0x75aa, 0x156a, 0x1096d,
    0x95c, 0x14ae, 0xaa4d, 0x1a4c, 0x1b2a, 0x8d55, 0xad4, 0x135a, 0x495d, 0x95c, 0xd49b, 0x149a, 0x1a4a, 0xbaa5,
    0x16a8, 0x1ad4, 0x52da, 0x12b6, 0xe937, 0x92e, 0x1496, 0xb64b, 0xd4a, 0xda8, 0x95b5, 0x56c, 0x12ae, 0x492f,
    0x92e, 0xcc96, 0x1a94, 0x1d4a, 0xada9, 0xb5a, 0x56c, 0x726e, 0x125c, 0xf92d, 0x192a, 0x1a94, 0xdb4a, 0x16aa,
    0xad4, 0x955b, 0x4ba, 0x125a, 0x592b, 0x152a, 0xf695, 0xd94, 0x16aa, 0xaab5, 0x9b4, 0x14b6, 0x6a57, 0xa56,
    0x1152a, 0x1d2a, 0xd54, 0xd5aa, 0x156a, 0x96c, 0x94ae, 0x14ae, 0xa4c, 0x7d26, 0x1b2a, 0xeb55, 0xad4, 0x12da,
    0xa95d, 0x95a, 0x149a, 0x9a4d, 0x1a4a, 0x11aa5, 0x16a8, 0x16d4, 0xd2da, 0x12b6, 0x936, 0x9497, 0x1496, 0x1564b,
    0xd4a, 0xda8, 0xd5b4, 0x156c, 0x12ae, 0xa92f, 0x92e, 0xc96, 0x6d4a, 0x1d4a, 0x10d65, 0xb58, 0x156c, 0xb26d,
    0x125c, 0x192c, 0x9a95, 0x1a94, 0x1b4a, 0x4b55, 0xad4, 0xf55b, 0x4ba, 0x125a, 0xb92b, 0x152a, 0x1694, 0x96aa,
    0x15aa, 0x12ab5, 0x974, 0x14b6, 0xca57, 0xa56, 0x1526, 0x8e95, 0xd54, 0x15aa, 0x49b5, 0x96c, 0xd4ae, 0x149c,
    0x1a4c, 0xbd26, 0x1aa6, 0xb54, 0x6d6a, 0x12da, 0x1695d, 0x95a, 0x149a, 0xda4b, 0x1a4a, 0x1aa4, 0xbb54, 0x16b4,
    0xada, 0x495b, 0x936, 0xf497, 0x1496, 0x154a, 0xb6a5, 0xda4, 0x15b4, 0x6ab6, 0x126e, 0x1092f, 0x92e, 0xc96,
    0xcd4a, 0x1d4a, 0xd64, 0x956c, 0x155c, 0x125c, 0x792e, 0x192c, 0xfa95, 0x1a94, 0x1b4a, 0xab55, 0xad4, 0x14da,
    0x8a5d, 0xa5a, 0x1152b, 0x152a, 0x1694, 0xd6aa, 0x15aa, 0xab4, 0x94ba, 0x14b6, 0xa56, 0x7527, 0xd26, 0xee53,
    0xd54, 0x15aa, 0xa9b5, 0x96c, 0x14ae, 0x8a4e, 0x1a4c, 0x11d26, 0x1aa4, 0x1b54, 0xcd6a, 0xada, 0x95c, 0x949d,
    0x149a, 0x1a2a, 0x5b25, 0x1aa4, 0xfb52, 0x16b4, 0xaba, 0xa95b, 0x936, 0x1496, 0x9a4b, 0x154a, 0x136a5, 0xda4,
    0x15ac
  ];
  static const List<int> SOLAR11 = [
    1887, 0xec04c, 0xec23f, 0xec435, 0xec649, 0xec83e, 0xeca51, 0xecc46, 0xece3a, 0xed04d, 0xed242, 0xed436,
    0xed64a, 0xed83f, 0xeda53, 0xedc48, 0xede3d, 0xee050, 0xee244, 0xee439, 0xee64d, 0xee842, 0xeea36, 0xeec4a,
    0xeee3e, 0xef052, 0xef246, 0xef43a, 0xef64e, 0xef843, 0xefa37, 0xefc4b, 0xefe41, 0xf0054, 0xf0248, 0xf043c,
    0xf0650, 0xf0845, 0xf0a38, 0xf0c4d, 0xf0e42, 0xf1037, 0xf124a, 0xf143e, 0xf1651, 0xf1846, 0xf1a3a, 0xf1c4e,
    0xf1e44, 0xf2038, 0xf224b, 0xf243f, 0xf2653, 0xf2848, 0xf2a3b, 0xf2c4f, 0xf2e45, 0xf3039, 0xf324d, 0xf3442,
    0xf3636, 0xf384a, 0xf3a3d, 0xf3c51, 0xf3e46, 0xf403b, 0xf424e, 0xf4443, 0xf4638, 0xf484c, 0xf4a3f, 0xf4c52,
    0xf4e48, 0xf503c, 0xf524f, 0xf5445, 0xf5639, 0xf584d, 0xf5a42, 0xf5c35, 0xf5e49, 0xf603e, 0xf6251, 0xf6446,
    0xf663b, 0xf684f, 0xf6a43, 0xf6c37, 0xf6e4b, 0xf703f, 0xf7252, 0xf7447, 0xf763c, 0xf7850, 0xf7a45, 0xf7c39,
    0xf7e4d, 0xf8042, 0xf8254, 0xf8449, 0xf863d, 0xf8851, 0xf8a46, 0xf8c3b, 0xf8e4f, 0xf9044, 0xf9237, 0xf944a,
    0xf963f, 0xf9853, 0xf9a47, 0xf9c3c, 0xf9e50, 0xfa045, 0xfa238, 0xfa44c, 0xfa641, 0xfa836, 0xfaa49, 0xfac3d,
    0xfae52, 0xfb047, 0xfb23a, 0xfb44e, 0xfb643, 0xfb837, 0xfba4a, 0xfbc3f, 0xfbe53, 0xfc048, 0xfc23c, 0xfc450,
    0xfc645, 0xfc839, 0xfca4c, 0xfcc41, 0xfce36, 0xfd04a, 0xfd23d, 0xfd451, 0xfd646, 0xfd83a, 0xfda4d, 0xfdc43,
    0xfde37, 0xfe04b, 0xfe23f, 0xfe453, 0xfe648, 0xfe83c, 0xfea4f, 0xfec44, 0xfee38, 0xff04c, 0xff241, 0xff436,
    0xff64a, 0xff83e, 0xffa51, 0xffc46, 0xffe3a, 0x10004e, 0x100242, 0x100437, 0x10064b, 0x100841, 0x100a53,
    0x100c48, 0x100e3c, 0x10104f, 0x101244, 0x101438, 0x10164c, 0x101842, 0x101a35, 0x101c49, 0x101e3d, 0x102051,
    0x102245, 0x10243a, 0x10264e, 0x102843, 0x102a37, 0x102c4b, 0x102e3f, 0x103053, 0x103247, 0x10343b, 0x10364f,
    0x103845, 0x103a38, 0x103c4c, 0x103e42, 0x104036, 0x104249, 0x10443d, 0x104651, 0x104846, 0x104a3a, 0x104c4e,
    0x104e43, 0x105038, 0x10524a, 0x10543e, 0x105652, 0x105847, 0x105a3b, 0x105c4f, 0x105e45, 0x106039, 0x10624c,
    0x106441, 0x106635, 0x106849, 0x106a3d, 0x106c51, 0x106e47, 0x10703c, 0x10724f, 0x107444, 0x107638, 0x10784c,
    0x107a3f, 0x107c53, 0x107e48
  ];
  static const int LUNAR_MONTH_FULL = 30;
  static const int LUNAR_MONTH_LACK = 29;

  SolarLunarConverter({this.year, this.month, this.day});

  /// Convert Solar date to Lunar date.
  ///
  /// Returns a [LunarDate].
  LunarDate toLunar() {
    int solarYearIdx = this.year - SOLAR11.first;
    int data = (this.year << 9) | (this.month << 5) | this.day;

    if (SOLAR11[solarYearIdx] > data) {
      solarYearIdx -= 1;
    }

    int solar11 = SOLAR11[solarYearIdx];
    int solarYear = this._getBitInt(solar11, 12, 9);
    int solarMonth = this._getBitInt(solar11, 4, 5);
    int solarDay = this._getBitInt(solar11, 5, 0);
    int lunarDay = this.solarToInt(this.year, this.month, this.day) -
        this.solarToInt(solarYear, solarMonth, solarDay);
    int lunarMonthDays = LUNAR_MONTH_DAYS[solarYearIdx];
    int leapDay = this._getBitInt(lunarMonthDays, 4, 13);
    int lunarYear = (solarYearIdx + SOLAR11.first);
    int lunarMonth = 1;
    bool isLeapYear = false;

    lunarDay += 1;

    for (int i = 0; i <= 12; i++) {
      int lunarDaysMonth = this._getBitInt(lunarMonthDays, 1, (12 - i)) == 1
          ? LUNAR_MONTH_FULL
          : LUNAR_MONTH_LACK;

      if (lunarDaysMonth >= lunarDay) {
        break;
      }

      lunarMonth += 1;
      lunarDay -= lunarDaysMonth;
    }

    if (leapDay != 0 && lunarMonth > leapDay) {
      isLeapYear = true;
      lunarMonth -= 1;
    }

    return LunarDate(lunarYear, lunarMonth, lunarDay, isLeapYear, leapDay);
  }

  int _getBitInt(int data, int length, int shift) =>
      (data & (((1 << length) - 1) << shift)) >> shift;

  int solarToInt(int solarYear, int solarMonth, int solarDay) {
    solarMonth = (solarMonth + 9) % 12;
    solarYear -= solarMonth ~/ 10;

    return (
        365 * solarYear + solarYear ~/ 4 - solarYear ~/ 100 +
            solarYear ~/ 400 + (solarMonth * 306 + 5) ~/ 10 + (solarDay - 1)
    );
  }
}

//void main() {
//  var slc = SolarLunarConverter(year: 1991, month: 3, day: 10);
//  LunarDate ld = slc.toLunar();
//  print(ld.toDate());
//  print(ld.getCanChiYear(ld.year));
//  print(ld.getCanChiMonth(ld.month, ld.year));
//  print(ld.getCanChiDay(10, 3, 1991));
//  print(ld.getCanChiHour(0, 10, 3, 1991));
//}