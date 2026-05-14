import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BibleReaderPage extends StatefulWidget {
  final String reference; // Example: "Genesis 1"

  const BibleReaderPage({required this.reference, Key? key}) : super(key: key);

  @override
  _BibleReaderPageState createState() => _BibleReaderPageState();
}

class _BibleReaderPageState extends State<BibleReaderPage> {
  late String currentBook;
  late int currentChapter;

  late Future<Map<String, dynamic>> chapterData;

  @override
  void initState() {
    super.initState();
    _parseReference(widget.reference);
    chapterData = _loadChapter();
  }

  void _parseReference(String ref) {
    // Example: "Genesis 1"
    final parts = ref.split(' ');
    currentBook = parts[0];
    currentChapter = int.parse(parts[1]);
  }

  Future<Map<String, dynamic>> _loadChapter() async {
    final url =
        "https://bible-api.com/$currentBook+$currentChapter?translation=web";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load chapter");
    }
  }

  void _nextChapter() {
    setState(() {
      currentChapter++;
      chapterData = _loadChapter();
    });
  }

  void _previousChapter() {
    if (currentChapter > 1) {
      setState(() {
        currentChapter--;
        chapterData = _loadChapter();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$currentBook $currentChapter")),
      body: FutureBuilder(
        future: chapterData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final verses = data["verses"];

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: verses.length,
                  itemBuilder: (context, index) {
                    final verse = verses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "${verse["verse"]}. ${verse["text"]}",
                        style: const TextStyle(fontSize: 18, height: 1.4),
                      ),
                    );
                  },
                ),
              ),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        currentChapter > 1 ? _previousChapter : null,
                    child: const Text("Previous Chapter"),
                  ),
                  ElevatedButton(
                    onPressed: _nextChapter,
                    child: const Text("Next Chapter"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
