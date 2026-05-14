import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const WarriorsBibleStudyApp());
}

class WarriorsBibleStudyApp extends StatelessWidget {
  const WarriorsBibleStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warriors Bible Study',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
