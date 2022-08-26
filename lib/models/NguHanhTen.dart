import '../utils/consts.dart';

class NguHanhTen {
  String nameId;
  String name;
  String type;

  NguHanhTen({this.nameId, this.name, this.type});

  factory NguHanhTen.fromJson(Map<String, dynamic> json) {
    return NguHanhTen(
      nameId: json['nameId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nameId': nameId,
    'name': name,
    'type': type,
  };

  int getTuongSinh(NguHanhTen b){
    if(this.type == b.type)
      return 0;
    else if (this.type == NGU_HANH[0] && b.type == NGU_HANH[2])
      return 1;
    else if (this.type == NGU_HANH[2] && b.type == NGU_HANH[1])
      return 1;
    else if (this.type == NGU_HANH[1] && b.type == NGU_HANH[3])
      return 1;
    else if (this.type == NGU_HANH[3] && b.type == NGU_HANH[4])
      return 1;
    else if (this.type == NGU_HANH[4] && b.type == NGU_HANH[0])
      return 1;
    else
      return -1;
  }

  int getTuongKhac(NguHanhTen b){
    if(this.type == b.type)
      return 0;
    else if (this.type == NGU_HANH[0] && b.type == NGU_HANH[1])
      return 1;
    else if (this.type == NGU_HANH[1] && b.type == NGU_HANH[4])
      return 1;
    else if (this.type == NGU_HANH[4] && b.type == NGU_HANH[2])
      return 1;
    else if (this.type == NGU_HANH[2] && b.type == NGU_HANH[3])
      return 1;
    else if (this.type == NGU_HANH[3] && b.type == NGU_HANH[0])
      return 1;
    else
      return -1;
  }

  getNguHanhTuongSinh(){
    List<String> nhTuongSinh = [];
    if (this.type == NGU_HANH[0]){
      nhTuongSinh.add(NGU_HANH[2]);
      nhTuongSinh.add(NGU_HANH[4]);
    } else if (this.type == NGU_HANH[1]) {
      nhTuongSinh.add(NGU_HANH[3]);
      nhTuongSinh.add(NGU_HANH[2]);
    } else if (this.type == NGU_HANH[2]) {
      nhTuongSinh.add(NGU_HANH[1]);
      nhTuongSinh.add(NGU_HANH[0]);
    } else if (this.type == NGU_HANH[3]) {
      nhTuongSinh.add(NGU_HANH[4]);
      nhTuongSinh.add(NGU_HANH[1]);
    } else if (this.type == NGU_HANH[4]) {
      nhTuongSinh.add(NGU_HANH[0]);
      nhTuongSinh.add(NGU_HANH[3]);
    }
    return nhTuongSinh;
  }

  @override
  String toString() {
    return "name: $name, type: $type";
  }
}