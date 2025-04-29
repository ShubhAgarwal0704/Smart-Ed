import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      foregroundColor: Color(0xFF212121),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFF212121),
      ),
      titleMedium: TextStyle(
        color: Color(0xFF757575),
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF212121),
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF616161),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF5F5F5),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1C1C1C),
      foregroundColor: Color(0xFFE0E0E0),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      color: Color(0xFF1C1C1C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFFE0E0E0),
      ),
      titleMedium: TextStyle(
        color: Color(0xFFB0BEC5),
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFE0E0E0),
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFFFFFFF),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1C1C1C),
    ),
  );
}
