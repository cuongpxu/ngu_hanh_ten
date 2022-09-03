class TongQuan {
  String expectedName;
  String expectedNameBreakDown;
  String score;
  String conclusion;

  TongQuan({
    this.expectedName,
    this.expectedNameBreakDown,
    this.score,
    this.conclusion
  });

  factory TongQuan.fromJson(Map<String, dynamic> json) {
    return TongQuan(
      expectedName: json['expectedName'] as String,
      expectedNameBreakDown: json['expectedNameBreakDown'] as String,
      score: json['score'] as String,
      conclusion: json['conclusion'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    'expectedName': expectedName,
    'expectedNameBreakDown': expectedNameBreakDown,
    'score': score,
    'conclusion': conclusion
  };

  @override
  String toString() {
    return "$expectedName\n$expectedNameBreakDown\n$score\n$conclusion";
  }
}