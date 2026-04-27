import 'package:flutter/material.dart';
import 'dart:io'; // Pro kontrolu, jestli jsem na Windows
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Pro Windows databázi
import 'services/database_helper.dart';
import 'screens/dashboard_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(153, 192, 35, 1),
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
