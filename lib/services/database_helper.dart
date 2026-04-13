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
  }

  Future<void> seedDatabase() async {
    final db = await instance.database;

    await db.delete('assignments'); // Clear existing data before seeding

    // Check if the table is empty before seeding
    List<Map> count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM assignments',
    );
    if (count.first['count'] == 0) {
      // list of tasks
      List<Map<String, dynamic>> dataset = [
        // --- YEAR 2, WINTER ---
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Winter',
          'title': 'System Design Report',
          'type': 'Report',
          'due_date': '2026-12-14',
          'estimated_hours': 12.0,
          'actual_hours': 15.0,
          'weight_percent': 30,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Mobile App Development',
          'year': 2,
          'semester': 'Winter',
          'title': 'UI/UX Presentation',
          'type': 'Presentation',
          'due_date': '2026-11-23',
          'estimated_hours': 8.0,
          'actual_hours': 6.0,
          'weight_percent': 20,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 2,
        },
        {
          'module_name': 'Cloud Computing',
          'year': 2,
          'semester': 'Winter',
          'title': 'Cloud Deployment Blog',
          'type': 'Blog',
          'due_date': '2026-11-16',
          'estimated_hours': 6.0,
          'actual_hours': 7.0,
          'weight_percent': 20,
          'status': 'Planned',
          'priority': 3,
          'complexity_score': 2,
        },
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Winter',
          'title': 'Data Analysis Task',
          'type': 'Practical Code',
          'due_date': '2026-12-07',
          'estimated_hours': 9.0,
          'actual_hours': 11.0,
          'weight_percent': 30,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Mobile App Development',
          'year': 2,
          'semester': 'Winter',
          'title': 'App Testing Report',
          'type': 'Report',
          'due_date': '2026-11-02',
          'estimated_hours': 7.0,
          'actual_hours': 6.0,
          'weight_percent': 30,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 2,
        },
        {
          'module_name': 'Cloud Computing',
          'year': 2,
          'semester': 'Winter',
          'title': 'Virtual Machines Setup',
          'type': 'Practical Code',
          'due_date': '2027-01-04',
          'estimated_hours': 12.0,
          'actual_hours': 14.0,
          'weight_percent': 40,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Cloud Computing',
          'year': 2,
          'semester': 'Winter',
          'title': 'Security Concepts Report',
          'type': 'Report',
          'due_date': '2027-01-11',
          'estimated_hours': 11.0,
          'actual_hours': 13.0,
          'weight_percent': 30,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 4,
        },

        // --- YEAR 2, SUMMER ---
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Prototype Evaluation',
          'type': 'Report',
          'due_date': '2027-04-12',
          'estimated_hours': 10.0,
          'actual_hours': 8.0,
          'weight_percent': 40,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 3,
        },
        {
          'module_name': 'Cross Platform Programming',
          'year': 2,
          'semester': 'Summer',
          'title': 'Mobile App Prototype',
          'type': 'Practical Code',
          'due_date': '2027-04-19',
          'estimated_hours': 20.0,
          'actual_hours': 24.0,
          'weight_percent': 50,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 5,
        },
        {
          'module_name': 'Architecture and Operating Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'System Processes Report',
          'type': 'Report',
          'due_date': '2027-04-26',
          'estimated_hours': 14.0,
          'actual_hours': 18.0,
          'weight_percent': 40,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Cross Platform Programming',
          'year': 2,
          'semester': 'Summer',
          'title': 'API Integration Task',
          'type': 'Practical Code',
          'due_date': '2027-05-03',
          'estimated_hours': 16.0,
          'actual_hours': 19.0,
          'weight_percent': 40,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Architecture and Operating Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Memory Management Essay',
          'type': 'Report',
          'due_date': '2027-05-10',
          'estimated_hours': 13.0,
          'actual_hours': 0.0,
          'weight_percent': 30,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 4,
        },
        {
          'module_name': 'Information Systems',
          'year': 2,
          'semester': 'Summer',
          'title': 'Dashboard Implementation',
          'type': 'Practical Code',
          'due_date': '2027-05-17',
          'estimated_hours': 18.0,
          'actual_hours': 0.0,
          'weight_percent': 40,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 5,
        },

        // --- YEAR 1, WINTER ---
        {
          'module_name': 'Introduction to Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Python Basics Assignment',
          'type': 'Practical Code',
          'due_date': '2026-01-12',
          'estimated_hours': 8.0,
          'actual_hours': 7.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 2,
        },
        {
          'module_name': 'Mathematical Concepts in Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Discrete Maths Test',
          'type': 'Report',
          'due_date': '2026-01-20',
          'estimated_hours': 10.0,
          'actual_hours': 12.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Professional and Academic Skills',
          'year': 1,
          'semester': 'Winter',
          'title': 'Reflective Blog',
          'type': 'Blog',
          'due_date': '2026-01-08',
          'estimated_hours': 5.0,
          'actual_hours': 4.0,
          'weight_percent': 20,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 1,
        },
        {
          'module_name': 'Introduction to Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Final Coding Project',
          'type': 'Practical Code',
          'due_date': '2026-01-30',
          'estimated_hours': 15.0,
          'actual_hours': 13.0,
          'weight_percent': 60,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Mathematical Concepts in Programming',
          'year': 1,
          'semester': 'Winter',
          'title': 'Probability Assignment',
          'type': 'Report',
          'due_date': '2026-02-02',
          'estimated_hours': 9.0,
          'actual_hours': 10.0,
          'weight_percent': 40,
          'status': 'Done',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Professional and Academic Skills',
          'year': 1,
          'semester': 'Winter',
          'title': 'Presentation Skills Task',
          'type': 'Presentation',
          'due_date': '2026-01-18',
          'estimated_hours': 6.0,
          'actual_hours': 5.0,
          'weight_percent': 20,
          'status': 'Done',
          'priority': 3,
          'complexity_score': 2,
        },

        // --- YEAR 1, SUMMER ---
        {
          'module_name': 'Database Concepts 1',
          'year': 1,
          'semester': 'Summer',
          'title': 'SQL Practical Task',
          'type': 'Practical Code',
          'due_date': '2026-04-27',
          'estimated_hours': 10.0,
          'actual_hours': 9.0,
          'weight_percent': 35,
          'status': 'In Progress',
          'priority': 2,
          'complexity_score': 3,
        },
        {
          'module_name': 'Algorithms and Data Structures',
          'year': 1,
          'semester': 'Summer',
          'title': 'Sorting Algorithms Report',
          'type': 'Report',
          'due_date': '2026-05-11',
          'estimated_hours': 15.0,
          'actual_hours': 20.0,
          'weight_percent': 50,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 5,
        },
        {
          'module_name': 'Software Engineering Practices 1',
          'year': 1,
          'semester': 'Summer',
          'title': 'Group Project Presentation',
          'type': 'Presentation',
          'due_date': '2026-05-25',
          'estimated_hours': 18.0,
          'actual_hours': 22.0,
          'weight_percent': 60,
          'status': 'Planned',
          'priority': 1,
          'complexity_score': 5,
        },
        {
          'module_name': 'Database Concepts 1',
          'year': 1,
          'semester': 'Summer',
          'title': 'Database Design Project',
          'type': 'Practical Code',
          'due_date': '2026-04-20',
          'estimated_hours': 14.0,
          'actual_hours': 16.0,
          'weight_percent': 50,
          'status': 'Done',
          'priority': 1,
          'complexity_score': 4,
        },
        {
          'module_name': 'Algorithms and Data Structures',
          'year': 1,
          'semester': 'Summer',
          'title': 'Graph Algorithms Task',
          'type': 'Practical Code',
          'due_date': '2026-05-04',
          'estimated_hours': 17.0,
          'actual_hours': 21.0,
          'weight_percent': 50,
          'status': 'In Progress',
          'priority': 1,
          'complexity_score': 5,
        },
        {
          'module_name': 'Software Engineering Practices 1',
          'year': 1,
          'semester': 'Summer',
          'title': 'Agile Workflow Blog',
          'type': 'Blog',
          'due_date': '2026-05-18',
          'estimated_hours': 8.0,
          'actual_hours': 9.0,
          'weight_percent': 30,
          'status': 'Planned',
          'priority': 2,
          'complexity_score': 3,
        },
      ];
      for (var row in dataset) {
        await db.insert('assignments', row);
      }
      print("Dataset successfully seeded!");
    }
  }

  // Function to get all assignments from the database, ordered by year, semester, and due date
  Future<List<Map<String, dynamic>>> getAllAssignments() async {
    final db = await instance.database;
    // query the database to get all assignments, ordered by year, semester (Winter before Summer), and due date
    return await db.query(
      'assignments',
      orderBy:
          'year ASC, CASE WHEN semester = "Winter" THEN 0 ELSE 1 END, due_date',
    );
  }
}
