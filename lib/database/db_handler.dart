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
      idRequested INTEGER
    )
  ''');
  }

  Future<void> updateState(bool idRequested) async {
    final Database db = await database;
    await db.insert('app_state', {'idRequested': idRequested});
  }

  Future<bool> getIdRequestedState() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('app_state');

    if (results.isNotEmpty) {
      return results.first['idRequested'] == 1;
    } else {
      return false;
    }
  }
}
