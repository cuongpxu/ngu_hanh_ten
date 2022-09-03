

class NguHanhScore {
  String title;
  String content1Title;
  String content1;
  String content2Title;
  String content2;
  String content3Title;
  String content3;
  String scoreTitle;
  int score;
  String scoreText;

  NguHanhScore({
    this.title,
    this.content1Title,
    this.content1,
    this.content2Title,
    this.content2,
    this.content3Title,
    this.content3,
    this.score,
    this.scoreText
  });

  factory NguHanhScore.fromJson(Map<String, dynamic> json) {
    return NguHanhScore(
      title: json['title'] as String,
      content1Title: json['content1Title'] as String,
      content1: json['content1'] as String,
      content2Title: json['content2Title'] as String,
      content2: json['content2'] as String,
      content3Title: json['content3Title'] as String,
      content3: json['content3'] as String,
      score: json['score'] as int,
      scoreText: json['scoreText'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content1Title': content1Title,
    'content1': content1,
    'content2Title': content2Title,
    'content2': content2,
    'content3Title': content3Title,
    'content3': content3,
    'score': score,
    'scoreText': scoreText,
  };

  @override
  String toString() {
    return "$title $content1Title $content1";
  }
}