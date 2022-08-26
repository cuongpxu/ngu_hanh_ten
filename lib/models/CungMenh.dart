
class CungMenh {
  int id;
  String name;
  int mod1;
  int mod2;

  CungMenh({this.id, this.name, this.mod1, this.mod2});

  factory CungMenh.fromJson(Map<String, dynamic> json) {
    return CungMenh(
      id: json['id'] as int,
      name: json['name'] as String,
      mod1: json['mod1'] as int,
      mod2: json['mod2'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'mod1': mod1,
    'mod2': mod2,
  };
}