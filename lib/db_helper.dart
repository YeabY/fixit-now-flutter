import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    _db ??= await initDB();
    return _db!;

  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final dbClient = await db;
    final res = await dbClient.query('users', where: 'username = ?', whereArgs: [username]);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'fixitnow.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          email TEXT,
          phone TEXT,
          password TEXT,
          role TEXT,
          serviceType TEXT
        )
      ''');
    });
  }

  Future<int> register(Map<String, dynamic> user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String username,
      String password) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }
}

