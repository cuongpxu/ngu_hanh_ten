import 'dart:math';
import 'package:intl/intl.dart';
import '../scenes/NguHanhPage.dart';
import '../databases/localDB.dart';
import '../models/NguHanhTen.dart';
import '../utils/consts.dart';

class NguHanhInput {
  String id;
  String firstname;
  String surname;
  Gender gender;
  DateTime kidDateBorn;
  DateTime dadDateBorn;
  DateTime momDateBorn;
  int isFavorite = 0;

  NguHanhInput(
  {
    this.id,
    this.firstname,
    this.surname,
    this.gender,
    this.kidDateBorn,
    this.dadDateBorn,
    this.momDateBorn,
    this.isFavorite
  });

  factory NguHanhInput.fromJson(Map<dynamic, dynamic> json) {
    final dateFormatter = DateFormat("dd/MM/yyyy");
    return NguHanhInput(
        id: json['id'] as String,
        surname: json['surname'] as String,
        firstname: json['firstname'] as String,
        gender: json['gender'] == 0 ? Gender.male : Gender.female,
        kidDateBorn: dateFormatter.parse(json['kidDateBorn']),
        dadDateBorn: dateFormatter.parse(json['dadDateBorn']),
        momDateBorn: dateFormatter.parse(json['momDateBorn']),
        isFavorite: json['isFavorite'] as int);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surname': surname,
        'firstname': firstname,
        'gender': gender == Gender.male ? 0 : 1,
        'kidDateBorn':
            new DateFormat("dd/MM/yyyy").format(kidDateBorn).toString(),
        'dadDateBorn':
            new DateFormat("dd/MM/yyyy").format(dadDateBorn).toString(),
        'momDateBorn':
            new DateFormat("dd/MM/yyyy").format(momDateBorn).toString(),
        'isFavorite': isFavorite
      };

  Future<String> getAllRelationshipName() async {
    String result = "";
    String fullname = surname.trim() + " " + firstname.trim();
    var names = fullname.split(" ");
    if (names.length == 2) {
      await getRelationshipName("Họ", names[0], "Tên", names[1]).then((value) {
        result += value;
      });
    } else if (names.length == 3) {
      await getRelationshipName("Họ", names[0], "Tên đệm", names[1])
          .then((value) {
        result += value + "\n";
      });
      await getRelationshipName("Tên đệm", names[1], "Tên", names[2])
          .then((value) {
        result += value;
      });
    } else if (names.length > 3) {
      await getRelationshipName("Họ", names[0], "Tên đệm", names[1])
          .then((value) {
        result += value + "\n";
      });
      for (int i = 1; i < names.length - 2; i++) {
        await getRelationshipName("Tên đệm " + i.toString(), names[i],
                "Tên đệm " + (i + 1).toString(), names[i + 1])
            .then((value) {
          result += value + "\n";
        });
      }
      await getRelationshipName("Tên đệm " + (names.length - 2).toString(),
              names[names.length - 2], "Tên", names[names.length - 1])
          .then((value) {
        result += value;
      });
    }
    return result;
  }

  Future<String> getRelationshipName(
      String o1, String name1, String o2, String name2) async {
    String result = "";
    NguHanhTen nht1;
    NguHanhTen nht2;

    await DBProvider.db.getNguHanhTenByName(name1).then((NguHanhTen nht) {
      nht1 = nht;
    });

    await DBProvider.db.getNguHanhTenByName(name2).then((NguHanhTen nht) {
      nht2 = nht;
    });

    if (nht1 == null || nht2 == null) {
      result =
          "Vì không xác định được hành của $o1 và $o2 nên xem như bình hòa.";
    } else {
      if (nht1.type == nht2.type) {
        result =
            "Chữ $name1 và chữ $name2 có cùng hành là ${nht1.type}, $kl_hoa_1.";
      } else {
        int tuongSinh = nht1.getTuongSinh(nht2);
        int tuongKhac = nht1.getTuongKhac(nht2);
        if (tuongSinh > 0) {
          result =
              "Chữ $name1 có hành là ${nht1.type} $tuong_sinh với chữ $name2 có hành là ${nht2.type}, $kl_tot!";
        } else if (tuongKhac > 0) {
          result =
              "Chữ $name1 có hành là ${nht1.type} $tuong_khac với chữ $name2 có hành là ${nht2.type}, $kl_xau!";
        } else {
          result =
              "Chữ $name1 có hành là ${nht1.type} $not_sinh_khac với chữ $name2 có hành là ${nht2.type}, $kl_trung_binh!";
        }
      }
    }
    return result;
  }

  String getConclusion(
      int score, String o1, String hanh1, String o2, String hanh2) {
    String result = "";
    if (score == 0) {
      result =
          "Hành của $o1 là $hanh1 $tuong_khac với Hành của $o2 là $hanh2, $kl_xau";
    } else if (score == 1) {
      result =
          "Hành của $o1 là $hanh1 $not_sinh_khac với Hành của $o2 là $hanh2, $kl_hoa";
    } else {
      result =
          "Hành của $o1 là $hanh1 $tuong_sinh với Hành của $o2 là $hanh2, $kl_tot";
    }
    return result;
  }

  String getGeneralConclusionByScore(int score) {
    if (score >= 0 && score <= 4) {
      return "Đây là một tên $kl_xau, sẽ tốt hơn nếu bạn chọn cho bé một tên khác";
    } else if (score <= 8) {
      return "Tên này $kl_trung_binh, sẽ tốt hơn nếu bạn chọn cho bé một tên khác";
    } else {
      if (score >= 9 && score < 11) {
        return "Đây là một tên khá đẹp, bạn có thể lựa chọn đặt cho bé tên này";
      }
      return "Đây là một tên $kl_tot, bạn có thể lựa chọn đặt cho bé tên này";
    }
  }

  Future<int> getScoreName() async {
    int score = 0;
    String fullname = surname.trim() + " " + firstname.trim();
    var names = fullname.split(" ");
    for (int i = 0; i < names.length - 1; i++) {
      NguHanhTen nht1;
      NguHanhTen nht2;

      await DBProvider.db.getNguHanhTenByName(names[i]).then((NguHanhTen nht) {
        nht1 = nht;
      });

      await DBProvider.db
          .getNguHanhTenByName(names[i + 1])
          .then((NguHanhTen nht) {
        nht2 = nht;
      });

      if (nht1 == null || nht2 == null) continue;
      score += getScore(nht1, nht2);
    }
    return min(score, 3);
  }

  int getScore(NguHanhTen nht1, NguHanhTen nht2) {
    int score;
    int tuongSinh = nht1.getTuongSinh(nht2);
    int tuongKhac = nht1.getTuongKhac(nht2);
    if (tuongSinh > 0)
      score = 2;
    else if (tuongKhac > 0)
      score = 0;
    else
      score = 1;
    return score;
  }
}
