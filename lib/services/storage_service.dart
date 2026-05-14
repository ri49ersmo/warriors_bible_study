import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/day_record.dart';

class StorageService {
  static const _historyKey = 'history';
  static const _dailyGoalKey = 'daily_goal';
  static const _streakKey = 'streak';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<List<DayRecord>> loadHistory() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_historyKey);
    if (jsonString == null) return [];
    final List list = json.decode(jsonString);
    return list.map((e) => DayRecord.fromJson(e)).toList();
  }

  Future<void> saveHistory(List<DayRecord> history) async {
    final prefs = await _prefs;
    final jsonString =
        json.encode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, jsonString);
  }

  Future<int> loadDailyGoal() async {
    final prefs = await _prefs;
    return prefs.getInt(_dailyGoalKey) ?? 20;
  }

  Future<void> saveDailyGoal(int minutes) async {
    final prefs = await _prefs;
    await prefs.setInt(_dailyGoalKey, minutes);
  }

  Future<int> loadStreak() async {
    final prefs = await _prefs;
    return prefs.getInt(_streakKey) ?? 0;
  }

  Future<void> saveStreak(int streak) async {
    final prefs = await _prefs;
    await prefs.setInt(_streakKey, streak);
  }

  String _todayString() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
  }

  String _yesterdayString() {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return "${y.year.toString().padLeft(4, '0')}-"
        "${y.month.toString().padLeft(2, '0')}-"
        "${y.day.toString().padLeft(2, '0')}";
  }

  Future<DayRecord?> loadTodayRecord() async {
    final history = await loadHistory();
    final today = _todayString();
    try {
      return history.firstWhere((r) => r.date == today);
    } catch (_) {
      return null;
    }
  }

  Future<void> addMinutesToToday(int minutesToAdd) async {
    if (minutesToAdd <= 0) return;

    final history = await loadHistory();
    final goal = await loadDailyGoal();
    final today = _todayString();
    final yesterday = _yesterdayString();
    int streak = await loadStreak();

    DayRecord? todayRecord;
    int index = history.indexWhere((r) => r.date == today);
    if (index != -1) {
      todayRecord = history[index];
    }

    final newMinutes = (todayRecord?.minutes ?? 0) + minutesToAdd;
    final completedGoal = newMinutes >= goal;

    bool streakContinued = todayRecord?.streakContinued ?? false;

    if (completedGoal && !(todayRecord?.completedGoal ?? false)) {
      // first time hitting goal today
      final yesterdayRecord =
          history.where((r) => r.date == yesterday).toList();
      final yesterdayCompleted =
          yesterdayRecord.isNotEmpty && (yesterdayRecord.first.completedGoal ?? false);
      if (yesterdayCompleted) {
        streak += 1;
      } else {
        streak = 1;
      }
      streakContinued = yesterdayCompleted;
      await saveStreak(streak);
    }

    final updated = DayRecord(
      date: today,
      minutes: newMinutes,
      verseReference: todayRecord?.verseReference,
      completedGoal: completedGoal,
      streakContinued: streakContinued,
    );

    if (index != -1) {
      history[index] = updated;
    } else {
      history.add(updated);
    }

    await saveHistory(history);
  }

  Future<void> resetAll() async {
    final prefs = await _prefs;
    await prefs.remove(_historyKey);
    await prefs.remove(_streakKey);
    // keep daily goal
  }
}
