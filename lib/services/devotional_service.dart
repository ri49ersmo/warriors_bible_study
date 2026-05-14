import 'dart:convert';
import 'package:flutter/services.dart';
import '../devotional.dart';

/// AUTO‑GENERATE A DEVOTIONAL WHEN JSON DOESN'T HAVE TODAY'S DATE
Devotional generateDevotionalForToday() {
  final now = DateTime.now();
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final themes = [
    {
      "title": "God Is With You",
      "verse": "Joshua 1:9",
      "text": "Be strong and courageous. God is with you wherever you go."
    },
    {
      "title": "Walk in His Strength",
      "verse": "Isaiah 40:31",
      "text": "Those who wait on the Lord will renew their strength."
    },
    {
      "title": "Peace for Today",
      "verse": "John 14:27",
      "text": "My peace I give to you. Do not let your heart be troubled."
    },
    {
      "title": "Trust His Plan",
      "verse": "Proverbs 3:5-6",
      "text": "Trust in the Lord with all your heart and He will direct your paths."
    }
  ];

  final index = now.day % themes.length;
  final theme = themes[index];

  return Devotional(
    date: formattedDate,
    title: theme["title"]!,
    verse: theme["verse"]!,
    text: theme["text"]!,
  );
}

/// LOAD DEVOTIONALS FROM JSON FILE
Future<Map<String, Devotional>> loadDevotionals() async {
  final jsonString =
      await rootBundle.loadString('assets/devotionals/devos.json');

  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  return jsonMap.map((date, data) {
    return MapEntry(date, Devotional.fromJson(date, data));
  });
}

/// GET TODAY'S DEVOTIONAL (JSON → OR AUTO‑GENERATED)
Future<Devotional> getTodayDevotional() async {
  final devotionals = await loadDevotionals();

  final now = DateTime.now();
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  if (devotionals.containsKey(formattedDate)) {
    return devotionals[formattedDate]!;
  }

  return generateDevotionalForToday();
}
