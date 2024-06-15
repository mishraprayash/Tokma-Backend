import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'tokma.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE app_state (
      idRequested INTEGER,
      userType TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE session (
      sessionId INTEGER PRIMARY KEY AUTOINCREMENT,
      authorization TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE guidesession (
      sessionId INTEGER PRIMARY KEY AUTOINCREMENT,
      authorization TEXT
    )
  ''');
  }

  Future<void> insertSession(String authorization) async {
    final Database db = await database;
    // Check if there is any existing session row
    List<Map<String, dynamic>> existingRows = await db.query('session');
    if (existingRows.isEmpty) {
      // If no rows exist, insert a new row
      Map<String, dynamic> row = {'authorization': authorization};
      await db.insert('session', row);
    } else {
      // If a row exists, update the existing row
      Map<String, dynamic> row = {'authorization': authorization};
      await db.update('session', row);
    }
  }

  Future<void> insertGuideSession(String authorization) async {
    final Database db = await database;
    // Check if there is any existing session row
    List<Map<String, dynamic>> existingRows = await db.query('guidesession');
    if (existingRows.isEmpty) {
      // If no rows exist, insert a new row
      Map<String, dynamic> row = {'authorization': authorization};
      await db.insert('guidesession', row);
    } else {
      // If a row exists, update the existing row
      Map<String, dynamic> row = {'authorization': authorization};
      await db.update('guidesession', row);
    }
  }

  Future<String?> getSession() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('session', limit: 1);

    if (results.isNotEmpty) {
      return results.first['authorization'] as String?;
    } else {
      return null; // Return null if no session row is found
    }
  }

  Future<String?> getGuideSession() async {
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query('guidesession', limit: 1);

    if (results.isNotEmpty) {
      return results.first['authorization'] as String?;
    } else {
      return null; // Return null if no session row is found
    }
  }

  Future<void> updateState(bool idRequested, String userType) async {
    final Database db = await database;

    // Clear existing state (only one row should exist)
    await db.delete('app_state');

    // Insert new state
    await db.insert(
      'app_state',
      {'idRequested': idRequested ? 1 : 0, 'userType': userType},
    );
  }

  Future<Map<String, dynamic>> getAppState() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('app_state');

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {'idRequested': 0, 'userType': ''};
    }
  }
}
