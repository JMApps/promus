import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'constants/table_names.dart';

class CityDatabaseHelper {
  CityDatabaseHelper._();

  static final CityDatabaseHelper instance = CityDatabaseHelper._();

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
    return p.join(dbDir, TableNames.cityDatabaseName);
  }

  Future<Database> _open() async {
    try {
      final dbPath = await _resolveDbPath();

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
    final installed = await _installedVersion(dbPath);
    if (installed >= _dbVersion) return;
    await _installFreshFromAssets(dbPath);
  }

  Future<int> _installedVersion(String dbPath) async {
    if (!await File(dbPath).exists()) return 0;

    Database? probe;
    try {
      probe = await openDatabase(dbPath, readOnly: true, singleInstance: false);
      return await probe.getVersion();
    } catch (_) {
      return 0;
    } finally {
      await probe?.close();
    }
  }

  Future<void> _installFreshFromAssets(String dbPath) async {
    await close();

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

  Future<Database> reinstallFromAssets() async {
    final pending = _opening;
    if (pending != null) {
      try {
        await pending;
      } catch (_) {}
    }

    final dbPath = await _resolveDbPath();
    await _installFreshFromAssets(dbPath);

    return db;
  }
}
