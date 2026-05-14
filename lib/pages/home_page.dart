import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/day_record.dart';
import 'bible_books_page.dart';
import 'devotional_page.dart';
import 'history_page.dart';
import 'settings_page.dart';
import '../widgets/warriors_progress_ring.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storage = StorageService();

  int _todayMinutes = 0;
  int _dailyGoal = 20;
  int _streak = 0;

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final goal = await _storage.loadDailyGoal();
    final streak = await _storage.loadStreak();
    final todayRecord = await _storage.loadTodayRecord();
    setState(() {
      _dailyGoal = goal;
      _streak = streak;
      _todayMinutes = todayRecord?.minutes ?? 0;
    });
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  Future<void> _stopTimer() async {
    _timer?.cancel();
    setState(() => _isRunning = false);

    final minutes = (_elapsedSeconds / 60).floor(); // accurate minutes
    _elapsedSeconds = 0;

    if (minutes <= 0) return;

    await _storage.addMinutesToToday(minutes);
    final todayRecord = await _storage.loadTodayRecord();
    final streak = await _storage.loadStreak();

    setState(() {
      _todayMinutes = todayRecord?.minutes ?? _todayMinutes + minutes;
      _streak = streak;
    });
  }

  double get _progress {
    if (_dailyGoal <= 0) return 0;
    final p = _todayMinutes / _dailyGoal;
    return p.clamp(0, 1);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTimerControls() {
    final minutesDisplay = (_elapsedSeconds / 60).toStringAsFixed(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Session: $minutesDisplay min",
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: const Text("Start"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _pauseTimer,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.amber),
            foregroundColor: Colors.amber,
          ),
          child: const Text("Pause"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _stopTimer,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.amber),
            foregroundColor: Colors.amber,
          ),
          child: const Text("Stop & Save"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalText = "Today: $_todayMinutes min";
    final streakText = "🔥 Streak: $_streak day${_streak == 1 ? '' : 's'}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIGHTY WARRIORS BIBLE STUDY',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/warriors_logo.jpg'),
              fit: BoxFit.cover,
              opacity: 0.25,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Sharpening each other in the Word',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      streakText,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      totalText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),
                    WarriorsProgressRing(
                      count: _todayMinutes,
                      goal: _dailyGoal,
                    ),
                    const SizedBox(height: 32),
                    _buildTimerControls(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BibleBooksPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Open Bible"),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DevotionalPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        foregroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Devotional of the Day"),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        foregroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("History"),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsPage(),
                          ),
                        );
                        final goal = await _storage.loadDailyGoal();
                        setState(() => _dailyGoal = goal);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        foregroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Settings"),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
