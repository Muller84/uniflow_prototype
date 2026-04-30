import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,

    // Globální font
    textTheme: GoogleFonts.outfitTextTheme(),

    // Colors
    primaryColor: togglPink,
    scaffoldBackgroundColor: Colors.white,

    // AppBar styl
    appBarTheme: AppBarTheme(
      backgroundColor: togglDark,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.outfit(
        color: togglPink,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // Button styl
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: togglPink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: togglLightPurple.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: togglPink, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: togglPink.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: togglPink, width: 2),
      ),
      labelStyle: TextStyle(color: togglDark, fontWeight: FontWeight.w500),
    ),
  );
}
