import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.indigo,
        secondary: Colors.indigoAccent,
      ),
      primaryColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey[50],
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: Colors.grey[900],
        displayColor: Colors.grey[900],
      ),
      appBarTheme: const AppBarTheme(
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.indigo.shade700,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      // dialogTheme removed for SDK compatibility
    );
  }

  static ThemeData blueTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(primary: Colors.blue.shade700, secondary: Colors.blueAccent),
      primaryColor: Colors.blue.shade700,
      scaffoldBackgroundColor: Colors.blue[50],
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade700, elevation: 3, centerTitle: true),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: Colors.blueGrey[900]),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.blue.shade800,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      // dialogTheme removed for SDK compatibility
    );
  }

  static ThemeData greenTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(primary: Colors.green.shade700, secondary: Colors.greenAccent),
      primaryColor: Colors.green.shade700,
      scaffoldBackgroundColor: Colors.green[50],
      appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade700, elevation: 3, centerTitle: true),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: Colors.green[900]),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.green.shade800,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      // dialogTheme removed for SDK compatibility
    );
  }
}
