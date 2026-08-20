import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _dbFileName = 'mushaf_database.db';
  static const String _assetPath = 'assets/databases/$_dbFileName';

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

  Future<Database> _open() async {
    try {
      final dbDir = await getDatabasesPath();
      final dbPath = p.join(dbDir, _dbFileName);

      await Directory(p.dirname(dbPath)).create(recursive: true);

      await _ensureDatabaseInstalled(dbPath);

      final database = await openDatabase(
        dbPath,
        singleInstance: true,
        readOnly: true,
      );

      _db = database;
      return database;
    } catch (e, s) {
      _db = null;
      log('Database open failed', error: e, stackTrace: s);
      rethrow;
    } finally {
      _opening = null;
    }
  }

  Future<void> _ensureDatabaseInstalled(String dbPath) async {
    final file = File(dbPath);

    if (!await file.exists()) {
      await _installFreshFromAssets(dbPath);
      return;
    }

    final isValid = await _isExistingDatabaseValid(dbPath);

    if (!isValid) {
      await _deleteCopiedDatabase(dbPath);
      await _installFreshFromAssets(dbPath);
      return;
    }

    final currentVersion = await _readDatabaseVersion(dbPath);

    if (currentVersion == _dbVersion) {
      return;
    }

    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);
  }

  Future<bool> _isExistingDatabaseValid(String dbPath) async {
    Database? probe;

    try {
      probe = await openDatabase(
        dbPath,
        singleInstance: false,
        readOnly: true,
      );

      await probe.rawQuery(
        '''
        SELECT name
        FROM sqlite_master
        WHERE type = ?
        LIMIT 1
        ''',
        ['table'],
      );

      return true;
    } catch (_) {
      return false;
    } finally {
      await probe?.close();
    }
  }

  Future<int> _readDatabaseVersion(String dbPath) async {
    Database? probe;

    try {
      probe = await openDatabase(
        dbPath,
        singleInstance: false,
        readOnly: true,
      );

      return await probe.getVersion();
    } finally {
      await probe?.close();
    }
  }

  Future<void> _installFreshFromAssets(String dbPath) async {
    await _copyAssetDbTo(dbPath);

    Database? rw;

    try {
      rw = await openDatabase(
        dbPath,
        singleInstance: false,
        readOnly: false,
      );

      await rw.execute('ANALYZE');
      await rw.setVersion(_dbVersion);
    } catch (e, s) {
      log('Fresh database install failed', error: e, stackTrace: s);

      await rw?.close();
      await _deleteCopiedDatabase(dbPath);

      rethrow;
    } finally {
      await rw?.close();
    }
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load(_assetPath);

    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    final file = File(dbPath);

    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _deleteCopiedDatabase(String dbPath) async {
    await close();

    if (await File(dbPath).exists()) {
      await deleteDatabase(dbPath);
    }
  }

  Future<void> close() async {
    _opening = null;

    final database = _db;
    _db = null;

    if (database != null && database.isOpen) {
      await database.close();
    }
  }

  Future<Database> reinstallFromAssets() async {
    final dbDir = await getDatabasesPath();
    final dbPath = p.join(dbDir, _dbFileName);

    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);

    return db;
  }
}