import 'package:flutter/material.dart';

final ThemeData warriorTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.white,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    secondary: Color(0xFFFFD700), // gold accent
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFFD700),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
);
