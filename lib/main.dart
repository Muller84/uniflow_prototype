import 'package:flutter/material.dart';
import 'dart:io'; // Pro kontrolu, jestli jsem na Windows
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Pro Windows databázi
import 'services/database_helper.dart';
import 'screens/dashboard_screen.dart';
import 'package:uniflow/theme/theme.dart';

void main() async {
  // 1. Initializace Flutteru
  WidgetsFlutterBinding.ensureInitialized();

  // --- WINDOWS ---
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit(); // Inicializuje ovladač
    databaseFactory =
        databaseFactoryFfi; // Řekne Flutteru: "Na Windows použij tohle"
  }
  // -----------------------------------------

  // 2. Spusteni aplikace
  runApp(const MyApp());

  // 3. Start databáze
  print("Seeding database...");
  DatabaseHelper.instance.seedDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniFlow',
      theme: buildTheme(),
      home: const DashboardScreen(),
    );
  }
}
