import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/day_record.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final StorageService _storage = StorageService();
  List<DayRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _storage.loadHistory();
    data.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _history = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("History"),
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                "No history yet",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final record = _history[index];
                final completed = record.completedGoal ?? false;
                final streakCont = record.streakContinued ?? false;

                return ListTile(
                  leading: completed
                      ? const Icon(Icons.check_circle,
                          color: Colors.amber)
                      : const Icon(Icons.radio_button_unchecked,
                          color: Colors.white54),
                  title: Text(
                    record.date,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "${record.minutes} minutes"
                    "${record.verseReference != null ? " • ${record.verseReference}" : ""}"
                    "${streakCont ? " • 🔥 streak continued" : ""}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
    );
  }
}
