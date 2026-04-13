import 'package:flutter/material.dart';
import 'dart:io'; // Pro kontrolu, jestli jsem na Windows
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Pro Windows databázi
import 'services/database_helper.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  // 1. Nutnost pro asynchronní operace
  WidgetsFlutterBinding.ensureInitialized();

  // --- TENTO BLOK JE PRO WINDOWS ---
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit(); // Inicializuje ovladač
    databaseFactory =
        databaseFactoryFfi; // Řekne Flutteru: "Na Windows použij tohle"
  }
  // -----------------------------------------

  // 2. Start databáze
  print("Startuji databázi...");
  await DatabaseHelper.instance.seedDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ), // colorsscheme from seed is a way to generate a color scheme based on a single seed color. It creates a harmonious palette of colors that can be used throughout the app, ensuring a consistent and visually appealing design.
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
