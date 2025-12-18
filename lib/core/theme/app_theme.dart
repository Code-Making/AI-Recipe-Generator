import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFFF6F00); // Amber/Orange
  static const Color secondaryColor = Color(0xFF4CAF50); // Green
  static const Color scaffoldBackgroundColorLight = Color(0xFFF5F5F5);
  static const Color scaffoldBackgroundColorDark = Color(0xFF121212);
  static const Color cardColorLight = Colors.white;
  static const Color cardColorDark = Color(0xFF1E1E1E);

  // Text Theme
  static TextTheme _textTheme(bool isDark) {
    return GoogleFonts.cairoTextTheme(
      // Cairo supports Arabic well
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColorLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: cardColorLight,
      ),
      cardTheme: CardTheme(
        color: cardColorLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColorLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      textTheme: _textTheme(false),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle:
              GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColorDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: cardColorDark,
      ),
      cardTheme: CardTheme(
        color: cardColorDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColorDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: _textTheme(true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle:
              GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
