import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'constants/table_names.dart';

class CustomCityDatabaseHelper {
  CustomCityDatabaseHelper._();

  static final CustomCityDatabaseHelper instance = CustomCityDatabaseHelper._();

  static const int _dbVersion = 1;

  Database? _db;
  Future<Database>? _opening;

  Future<Database> get db {
    final existing = _db;
    if (existing != null && existing.isOpen) {
      return Future.value(existing);
    }

    final opening = _opening;
    if (opening != null) return opening;

    final future = _open();
    _opening = future;
    return future;
  }

  Future<String> _resolveDbPath() async {
    final dbDir = await getDatabasesPath();
    return p.join(dbDir, TableNames.customCityDatabaseName);
  }

  Future<Database> _open() async {
    final dbPath = await _resolveDbPath();
    return _db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, _) => db.execute(
        '''
        CREATE TABLE ${TableNames.tableOfCityCoordinates} (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        country TEXT NOT NULL, 
        city TEXT NOT NULL, 
        latitude REAL NOT NULL, 
        longitude REAL NOT NULL)
        ''',
      ),
    );
  }
}
