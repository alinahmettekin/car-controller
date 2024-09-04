import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 14),
      bodyMedium: TextStyle(fontSize: 11),
      bodySmall: TextStyle(fontSize: 9),
    ),
  );
}
