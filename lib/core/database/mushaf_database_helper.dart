import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'constants/table_names.dart';

class MushafDatabaseHelper {
  MushafDatabaseHelper._();

  static final MushafDatabaseHelper instance = MushafDatabaseHelper._();

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
    return p.join(dbDir, TableNames.mushafDatabaseName);
  }

  Future<Database> _open() async {
    try {
      final dbPath = await _resolveDbPath();

      if (!await _isInstalledAndCurrent(dbPath)) {
        await _copyAssetDbTo(dbPath);
      }

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

  Future<bool> _isInstalledAndCurrent(String dbPath) async {
    if (!await File(dbPath).exists()) return false;

    Database? probe;
    try {
      probe = await openDatabase(
        dbPath,
        singleInstance: false,
        readOnly: true,
      );
      return await probe.getVersion() == _dbVersion;
    } catch (_) {
      return false;
    } finally {
      await probe?.close();
    }
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load(
      '${TableNames.databasesPath}${TableNames.mushafDatabaseName}',
    );

    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await Directory(p.dirname(dbPath)).create(recursive: true);

    final tmp = File('$dbPath.tmp');
    try {
      await tmp.writeAsBytes(bytes, flush: true);
      await _deleteCopiedDatabase(dbPath);
      await tmp.rename(dbPath);
    } catch (e, s) {
      log('Asset database copy failed', error: e, stackTrace: s);
      if (await tmp.exists()) await tmp.delete();
      rethrow;
    }
  }

  Future<void> _deleteCopiedDatabase(String dbPath) async {
    await close();

    if (await File(dbPath).exists()) {
      await deleteDatabase(dbPath);
    }
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
    await _copyAssetDbTo(dbPath);

    return db;
  }
}
