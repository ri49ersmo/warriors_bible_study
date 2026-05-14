class DayRecord {
  final String date; // yyyy-MM-dd
  final int minutes;
  final String? verseReference;
  final bool? completedGoal;
  final bool? streakContinued;

  DayRecord({
    required this.date,
    required this.minutes,
    this.verseReference,
    this.completedGoal,
    this.streakContinued,
  });

  Map<String, dynamic> toJson() => {
        "date": date,
        "minutes": minutes,
        "verseReference": verseReference,
        "completedGoal": completedGoal,
        "streakContinued": streakContinued,
      };

  factory DayRecord.fromJson(Map<String, dynamic> json) {
    return DayRecord(
      date: json["date"],
      minutes: json["minutes"],
      verseReference: json["verseReference"],
      completedGoal: json["completedGoal"],
      streakContinued: json["streakContinued"],
    );
  }
}
