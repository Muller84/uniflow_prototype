import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,

    // Globální font
    textTheme: GoogleFonts.outfitTextTheme(),

    // Background
    scaffoldBackgroundColor: uniBackground,

    // Primární barva aplikace
    primaryColor: uniPrimary,

    // AppBar styl
    appBarTheme: AppBarTheme(
      backgroundColor: uniPrimary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.outfit(
        color: uniAccentBlue,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // Tlačítka
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: uniAccentBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),

    // TextField styl
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: uniAccentBlue, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: uniAccentBlue.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: uniAccentBlue, width: 2),
      ),
      labelStyle: TextStyle(color: uniPrimary, fontWeight: FontWeight.w500),
    ),
  );
}
