import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseLogs {
  static final DatabaseLogs instance = DatabaseLogs._init();
  static Database? _database;

  DatabaseLogs._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('logs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> logOperation(String operation) async {
    final db = await instance.database;
    final now = DateTime.now().toIso8601String();
    await db.insert('logs', {
      'operation': operation,
      'timestamp': now,
    });
  }

  Future<List<Map<String, dynamic>>> readLogs() async {
    final db = await instance.database;
    return await db.query('logs', orderBy: 'timestamp DESC');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
