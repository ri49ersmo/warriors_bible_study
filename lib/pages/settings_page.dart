import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final StorageService _storage = StorageService();
  final TextEditingController _goalController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final goal = await _storage.loadDailyGoal();
    setState(() {
      _goalController.text = goal.toString();
    });
  }

  Future<void> _saveGoal() async {
    final text = _goalController.text.trim();
    final value = int.tryParse(text);
    if (value == null || value <= 0) return;

    setState(() {
      _saving = true;
    });
    await _storage.saveDailyGoal(value);
    setState(() {
      _saving = false;
    });
    if (mounted) Navigator.pop(context);
  }

  Future<void> _resetAll() async {
    setState(() {
      _saving = true;
    });
    await _storage.resetAll();
    setState(() {
      _saving = false;
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Warriors Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Daily goal (minutes):",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(),
                hintText: "20",
                hintStyle: TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _saveGoal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: Text(_saving ? "Saving..." : "Save Goal"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Danger zone",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _saving ? null : _resetAll,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                foregroundColor: Colors.redAccent,
              ),
              child: const Text("Reset history & streak"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Notes:\n"
              "• Streak increases when you hit your daily goal.\n"
              "• Reset clears history and streak but keeps your goal.\n"
              "• Bible and devotion remain available as usual.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
