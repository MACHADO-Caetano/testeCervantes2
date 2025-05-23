import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'databaseLog.dart';
import 'user.dart';

class DatabaseUser {
  static final DatabaseUser instance = DatabaseUser._init();
  static Database? _database;

  DatabaseUser._init();

  Future<User?> readByCodUser(int codUser) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'codUser = ?',
      whereArgs: [codUser],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      codUser INTEGER PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');
  }

  Future<int> create(User user) async {
    if (user.codUser! <= 0) {
    throw Exception('O código do usuário deve ser maior que 0.');
    }
    if (user.name.trim().isEmpty) {
      throw Exception('O nome não pode ser vazio.');
    }
    try {
      final db = await instance.database;
      final id = await db.insert('users', user.toMap());
      await DatabaseLogs.instance.logOperation('CREATE: User ${user.codUser}');
      return id;
    } catch (e) {
      print('Erro ao inserir usuário: $e');
      return -1;
    }
  }

  Future<List<User>> readAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<int> update(User user) async {
  if (user.name.trim().isEmpty) {
    throw Exception('O nome não pode ser vazio.');
  }

  if (user.codUser! <= 0) {
    throw Exception('O código do usuário deve ser maior que 0.');
  }

  final db = await instance.database;
  final result = await db.update(
    'users',
    user.toMap(),
    where: 'coduser = ?',
    whereArgs: [user.codUser],
  );
  await DatabaseLogs.instance.logOperation('UPDATE: User ${user.codUser}');
  return result;
  }

  Future<int> delete(int codUser) async {
    final db = await instance.database;
    final result = await db.delete(
      'users',
      where: 'coduser = ?',
      whereArgs: [codUser],
    );
    await DatabaseLogs.instance.logOperation('DELETE: User $codUser');
    return result;
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
