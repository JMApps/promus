import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'constants/table_names.dart';

class CityDatabaseHelper {
  static const int _dbVersion = 1;

  Database? _db;

  Future<String> _resolveDbPath() async {
    final dbDir = await getDatabasesPath();
    return p.join(dbDir, TableNames.cityDatabaseName);
  }

  Future<Database> open() async {
    final dbPath = await _resolveDbPath();
    await Directory(p.dirname(dbPath)).create(recursive: true);

    try {
      var database = await _openIfCurrent(dbPath);

      if (database == null) {
        await _installFreshFromAssets(dbPath);
        database = await _openReadOnly(dbPath);
      }

      return _db = database;
    } catch (e, s) {
      log('Database open failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<Database> _openReadOnly(String dbPath) {
    return openDatabase(
      dbPath,
      readOnly: true,
      singleInstance: false,
    );
  }

  /// Открывает установленную базу, если она есть и версия актуальна.
  /// Иначе возвращает null (файла нет, битый файл или старая версия).
  Future<Database?> _openIfCurrent(String dbPath) async {
    if (!await File(dbPath).exists()) return null;

    Database? database;
    try {
      database = await _openReadOnly(dbPath);
      if (await database.getVersion() >= _dbVersion) return database;
    } catch (_) {}

    await database?.close();
    return null;
  }

  Future<void> _installFreshFromAssets(String dbPath) async {
    final tmpPath = '$dbPath.tmp';
    Database? rw;

    try {
      await _copyAssetDbTo(tmpPath);

      rw = await openDatabase(tmpPath, singleInstance: false);
      await rw.execute('ANALYZE');
      await rw.setVersion(_dbVersion);
      await rw.close();
      rw = null;

      await File(tmpPath).rename(dbPath);
    } catch (e, s) {
      log('Database install failed', error: e, stackTrace: s);
      await rw?.close();
      final tmp = File(tmpPath);
      if (await tmp.exists()) await tmp.delete();
      rethrow;
    }
  }

  Future<void> _copyAssetDbTo(String path) async {
    final data = await rootBundle.load(
      '${TableNames.databasesPath}${TableNames.cityDatabaseName}',
    );

    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await File(path).writeAsBytes(bytes, flush: true);
  }

  Future<void> close() async {
    final database = _db;
    _db = null;

    if (database != null && database.isOpen) {
      await database.close();
    }
  }
}