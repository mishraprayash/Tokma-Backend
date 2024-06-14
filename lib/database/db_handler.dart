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
      userid TEXT,
      cookie TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE details (
      fname TEXT,
      lname TEXT,
      email TEXT,
      phnumber TEXT,
      country TEXT,
      gender TEXT,
      age TEXT,
      password TEXT,
      emergencycontact TEXT,
      emergencyemail TEXT
    )
  ''');
  }

  Future<void> updateState(bool idRequested, String userType) async {
    final Database db = await database;
    await db.insert('app_state',
        {'idRequested': idRequested ? 1 : 0, 'userType': userType});
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
