class Devotional {
  final String date;
  final String title;
  final String verse;
  final String text;

  Devotional({
    required this.date,
    required this.title,
    required this.verse,
    required this.text,
  });

  factory Devotional.fromJson(String date, Map<String, dynamic> json) {
    return Devotional(
      date: date,
      title: json['title'],
      verse: json['verse'],
      text: json['text'],
    );
  }
}
