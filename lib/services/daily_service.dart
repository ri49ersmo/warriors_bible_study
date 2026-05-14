import 'package:shared_preferences/shared_preferences.dart';

class DailyService {
  static const String _keyDate = "daily_date";
  static const String _keyMinutes = "daily_minutes";
  static const String _keyStreak = "daily_streak";

  Future<int> loadTodayMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_keyDate);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (savedDate != today) {
      await prefs.setString(_keyDate, today);
      await prefs.setInt(_keyMinutes, 0);
      return 0;
    }

    return prefs.getInt(_keyMinutes) ?? 0;
  }

  Future<void> saveTodayMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    await prefs.setString(_keyDate, today);
    await prefs.setInt(_keyMinutes, minutes);
  }

  Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStreak) ?? 0;
  }

  Future<void> updateStreak({required bool readToday}) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(_keyDate);
    int streak = prefs.getInt(_keyStreak) ?? 0;

    if (!readToday) return;

    if (savedDate == today) {
      return;
    }

    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);

    if (savedDate == yesterday) {
      streak += 1;
    } else {
      streak = 1;
    }

    await prefs.setString(_keyDate, today);
    await prefs.setInt(_keyStreak, streak);
  }
}
