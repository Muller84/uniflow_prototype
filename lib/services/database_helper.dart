import 'package:sqflite/sqflite.dart'; // library for SQLite database
import 'package:path/path.dart'; // library for handling file paths

class DatabaseHelper {
  // create a one instance of the DatabaseHelper class
  static final DatabaseHelper instance = DatabaseHelper._init();
  // variable to hold the database instance
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    // if the database exists, return it
    if (_database != null) return _database!;
    // if the database does not exist, create it
    _database = await _initDB('uniflow.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // where to store the database file
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // open the database, creating it if it does not exist
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // statement in sql, create a table 'assignments'
    await db.execute('''
    CREATE TABLE assignments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      module_name TEXT NOT NULL,
      year INTEGER NOT NULL,
      semester TEXT NOT NULL,
      title TEXT NOT NULL,
      type TEXT NOT NULL,
      due_date TEXT NOT NULL,
      estimated_hours REAL NOT NULL,
      actual_hours REAL NOT NULL,
      weight_percent INTEGER NOT NULL,
      status TEXT NOT NULL,
      priority INTEGER NOT NULL,
      complexity_score INTEGER NOT NULL
    )
  ''');

    // Time logs
    await db.execute('''
    CREATE TABLE time_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      assignment_id INTEGER NOT NULL,
      hours REAL NOT NULL,
      log_date TEXT NOT NULL,
      description TEXT,
      FOREIGN KEY (assignment_id) REFERENCES assignments (id) ON DELETE CASCADE
  )
  ''');
  }

  Future<void> seedDatabase() async {
    final db = await instance.database;

    // Check if the table is empty before seeding
    List<Map> count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM assignments',
    );
    if ((count.first['count'] as int) != 0) return;

    {
      // list of tasks
      List<Map<String, dynamic>> dataset = [
        // ==========================================
        // YEAR 1 (2024/2025)
        // ==========================================

        // --- Introduction to Programming ---
        {
          'module_name': 'Introduction to Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Formative: Basic Logic & Syntax',
          'type': 'Feedback',
          'due_date': '2024-10-10',
          'estimated_hours': 5.0,
          'actual_hours': 4.5,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 2,
        },
        {
          'module_name': 'Introduction to Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Summative 1: Language Comparison Report',
          'type': 'Coursework',
          'due_date': '2024-10-25',
          'estimated_hours': 15.0,
          'actual_hours': 14.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Introduction to Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Summative 2: Noughts & Crosses Design',
          'type': 'Practical',
          'due_date': '2024-12-10',
          'estimated_hours': 25.0,
          'actual_hours': 30.0,
          'weight_percent': 60,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },

        // --- Mathematical Concepts in Programming ---
        {
          'module_name': 'Mathematical Concepts in Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Formative: Math Logic Draft',
          'type': 'Feedback',
          'due_date': '2024-11-15',
          'estimated_hours': 4.0,
          'actual_hours': 4.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Mathematical Concepts in Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Summative 1: Traffic Flow Prediction',
          'type': 'Coursework',
          'due_date': '2024-12-05',
          'estimated_hours': 20.0,
          'actual_hours': 22.5,
          'weight_percent': 60,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Mathematical Concepts in Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Summative 2: Boolean Algebra & Power BI',
          'type': 'Practical',
          'due_date': '2025-01-10',
          'estimated_hours': 18.0,
          'actual_hours': 16.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 4,
        },

        // --- Professional and Academic Skills ---
        {
          'module_name': 'Professional and Academic Skills',
          'year': 1,
          'semester': 'Winter',
          'title': 'Formative: Skills Audit',
          'type': 'Feedback',
          'due_date': '2024-10-14',
          'estimated_hours': 3.0,
          'actual_hours': 3.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 1,
        },
        {
          'module_name': 'Professional and Academic Skills',
          'year': 1,
          'semester': 'Winter',
          'title': 'Summative 1: Academic Blog Posts',
          'type': 'Coursework',
          'due_date': '2025-01-06',
          'estimated_hours': 12.0,
          'actual_hours': 15.0,
          'weight_percent': 60,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 2,
        },
        {
          'module_name': 'Professional and Academic Skills',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 2: Digital Portfolio & Video',
          'type': 'Practical',
          'due_date': '2025-05-20',
          'estimated_hours': 15.0,
          'actual_hours': 16.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },

        // --- Database Concepts and Programming ---
        {
          'module_name': 'Database Concepts and Programming',
          'year': 1,
          'semester': 'Summer',
          'title': 'Formative: ERD Design Feedback',
          'type': 'Feedback',
          'due_date': '2025-03-10',
          'estimated_hours': 6.0,
          'actual_hours': 5.5,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Database Concepts and Programming',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 1: SQL Fundamentals',
          'type': 'Practical',
          'due_date': '2025-03-25',
          'estimated_hours': 15.0,
          'actual_hours': 18.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Database Concepts and Programming',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 2: Database Design (Game Knight)',
          'type': 'Practical',
          'due_date': '2025-05-01',
          'estimated_hours': 25.0,
          'actual_hours': 22.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },

        // --- Algorithms and Data Structures ---
        {
          'module_name': 'Algorithms and Data Structures',
          'year': 1,
          'semester': 'Summer',
          'title': 'Formative: Logic Check',
          'type': 'Feedback',
          'due_date': '2025-03-05',
          'estimated_hours': 5.0,
          'actual_hours': 5.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Algorithms and Data Structures',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 1: Big O Presentation',
          'type': 'Coursework',
          'due_date': '2025-03-20',
          'estimated_hours': 10.0,
          'actual_hours': 12.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 4,
        },
        {
          'module_name': 'Algorithms and Data Structures',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 2: Card Game (War) Python',
          'type': 'Practical',
          'due_date': '2025-05-10',
          'estimated_hours': 30.0,
          'actual_hours': 35.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 5,
        },

        // --- Software Engineering Practices ---
        {
          'module_name': 'Software Engineering Practices',
          'year': 1,
          'semester': 'Summer',
          'title': 'Formative: Methodology Draft',
          'type': 'Feedback',
          'due_date': '2025-03-15',
          'estimated_hours': 4.0,
          'actual_hours': 4.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Software Engineering Practices',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 1: Noughts & Crosses Documentation',
          'type': 'Coursework',
          'due_date': '2025-04-05',
          'estimated_hours': 15.0,
          'actual_hours': 14.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Software Engineering Practices',
          'year': 1,
          'semester': 'Summer',
          'title': 'Summative 2: FlipDev Hybrid Document',
          'type': 'Coursework',
          'due_date': '2025-05-15',
          'estimated_hours': 20.0,
          'actual_hours': 19.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },

        // ==========================================
        // YEAR 2 (2025/2026)
        // ==========================================

        // --- Cloud Computing ---
        {
          'module_name': 'Cloud Computing',
          'year': 2,
          'semester': 'Winter',
          'title': 'Formative: Cloud Architecture Plan',
          'type': 'Feedback',
          'due_date': '2025-10-15',
          'estimated_hours': 6.0,
          'actual_hours': 6.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Cloud Computing',
          'year': 2,
          'semester': 'Winter',
          'title': 'Summative 1: Architecture Report',
          'type': 'Coursework',
          'due_date': '2025-11-03',
          'estimated_hours': 20.0,
          'actual_hours': 21.5,
          'weight_percent': 60,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Cloud Computing',
          'year': 2,
          'semester': 'Winter',
          'title': 'Summative 2: Implementation',
          'type': 'Practical',
          'due_date': '2026-01-05',
          'estimated_hours': 18.0,
          'actual_hours': 20.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 4,
        },

        // --- Mobile App Development ---
        {
          'module_name': 'Mobile App Development',
          'year': 2,
          'semester': 'Winter',
          'title': 'Formative: UI/UX Wireframes',
          'type': 'Feedback',
          'due_date': '2025-10-05',
          'estimated_hours': 8.0,
          'actual_hours': 10.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Mobile App Development',
          'year': 2,
          'semester': 'Winter',
          'title': 'Summative 1: Research Report',
          'type': 'Coursework',
          'due_date': '2025-10-20',
          'estimated_hours': 15.0,
          'actual_hours': 14.5,
          'weight_percent': 30,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Mobile App Development',
          'year': 2,
          'semester': 'Winter',
          'title': 'Summative 2: Practical App Build',
          'type': 'Practical',
          'due_date': '2025-12-15',
          'estimated_hours': 40.0,
          'actual_hours': 45.0,
          'weight_percent': 70,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 5,
        },

        // --- Information Systems ---
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Winter',
          'title': 'Formative: Case Study Draft',
          'type': 'Feedback',
          'due_date': '2025-11-10',
          'estimated_hours': 5.0,
          'actual_hours': 5.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Winter',
          'title': 'Summative 1: IS Report',
          'type': 'Coursework',
          'due_date': '2025-12-01',
          'estimated_hours': 20.0,
          'actual_hours': 21.0,
          'weight_percent': 60,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 2: Prototype IS (Final Project)',
          'type': 'Practical',
          'due_date': '2026-05-04',
          'estimated_hours': 30.0,
          'actual_hours': 15.0,
          'weight_percent': 40,
          'status': 'In Progress',
          'priority': 1,
          'complexity_score': 5,
        },

        // --- Work Based Learning ---
        {
          'module_name': 'Work Based Learning',
          'year': 2,
          'semester': 'Summer',
          'title': 'Formative: Reflection Draft',
          'type': 'Feedback',
          'due_date': '2026-02-15',
          'estimated_hours': 4.0,
          'actual_hours': 4.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 2,
        },
        {
          'module_name': 'Work Based Learning',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 1: Coursework (Work Skills)',
          'type': 'Coursework',
          'due_date': '2026-03-23',
          'estimated_hours': 15.0,
          'actual_hours': 14.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Work Based Learning',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 2: Poster Presentation',
          'type': 'Practical',
          'due_date': '2026-04-27',
          'estimated_hours': 10.0,
          'actual_hours': 0.0,
          'weight_percent': 50,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 3,
        },

        // --- Cross Platform Programming ---
        {
          'module_name': 'Cross Platform Programming',
          'year': 2,
          'semester': 'Summer',
          'title': 'Formative: Framework Selection',
          'type': 'Feedback',
          'due_date': '2026-02-10',
          'estimated_hours': 5.0,
          'actual_hours': 5.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Cross Platform Programming',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 1: Framework Comparison',
          'type': 'Coursework',
          'due_date': '2026-03-02',
          'estimated_hours': 15.0,
          'actual_hours': 15.5,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Cross Platform Programming',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 2: Prototype Build',
          'type': 'Practical',
          'due_date': '2026-05-18',
          'estimated_hours': 35.0,
          'actual_hours': 12.0,
          'weight_percent': 50,
          'status': 'In Progress',
          'priority': 1,
          'complexity_score': 5,
        },

        // --- Architecture and Operating Systems ---
        {
          'module_name': 'Architecture and Operating Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Formative: OS Security Research',
          'type': 'Feedback',
          'due_date': '2026-02-25',
          'estimated_hours': 5.0,
          'actual_hours': 5.0,
          'weight_percent': 0,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 3,
        },
        {
          'module_name': 'Architecture and Operating Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 1: Security Report',
          'type': 'Coursework',
          'due_date': '2026-03-09',
          'estimated_hours': 18.0,
          'actual_hours': 17.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Architecture and Operating Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Summative 2: North Shore Case Study',
          'type': 'Coursework',
          'due_date': '2026-05-11',
          'estimated_hours': 25.0,
          'actual_hours': 0.0,
          'weight_percent': 60,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 4,
        },
      ];
      for (var row in dataset) {
        await db.insert('assignments', row);
      }

      print("Dataset successfully seeded!");
    }
  }

  // 1. Function to get all assignments from the database, ordered by year, semester, and due date
  Future<List<Map<String, dynamic>>> getAllAssignments() async {
    final db = await instance.database;
    // query the database to get all assignments, ordered by year, semester (Winter before Summer), and due date
    return await db.query(
      'assignments',
      orderBy:
          'year ASC, CASE WHEN semester = "Winter" THEN 0 ELSE 1 END, due_date',
    );
  }

  // 2. Function to add a time log entry for a specific assignment
  Future<int> addTimeLog(
    int assignmentId,
    double hours,
    String description,
  ) async {
    final db = await instance.database;
    // Insert a new time log entry
    return await db.insert('time_logs', {
      'assignment_id': assignmentId,
      'hours': hours,
      'log_date': DateTime.now().toIso8601String(),
      'description': description,
    });
  }

  // 3. Function to get the actual hours for a specific assignment
  Future<double> getActualHours(int assignmentId) async {
    final db = await instance.database;

    // SQL question, get the sum of hours for specific assignment id
    final result = await db.rawQuery(
      'SELECT SUM(hours) as total_hours FROM time_logs WHERE assignment_id = ?',
      [assignmentId],
    );

    // Take care of the result
    if (result.first['total_hours'] != null) {
      // Sqflite somethimes returns num, I will transfer it to double
      return (result.first['total_hours'] as num).toDouble();
    } else {
      return 0.0;
    }
  }
}
