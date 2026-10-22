import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:promus/core/constants/app_constants.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<Database> _open() async {
    try {
      final dbDir = await getDatabasesPath();
      final dbPath = p.join(dbDir, AppConstants.mushafDatabaseName);

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

      await rw.transaction(_createSearchFts);

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

  Future<void> _createSearchFts(Transaction txn) async {
    await txn.execute('DROP TABLE IF EXISTS fts_ayahs');

    await txn.execute(
      '''
    CREATE VIRTUAL TABLE fts_ayahs
    USING fts4(
      ayah_normalized,
      ayah_ru_kuliev,
      ayah_ru_adel,
      tokenize=unicode61
    )
    ''',
    );

    await txn.execute(
      '''
    INSERT INTO fts_ayahs(rowid, ayah_normalized, ayah_ru_kuliev, ayah_ru_adel)
    SELECT
      a.ayah_id,
      a.ayah_normalized,
      COALESCE(t.ayah_ru_kuliev, ''),
      COALESCE(t.ayah_ru_adel, '')
    FROM Table_of_ayah_by_ayah a
    LEFT JOIN Table_of_translation t ON t.ayah_key = a.verse_key
    ''',
    );
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load('${AppConstants.databasesPath}${AppConstants.mushafDatabaseName}');

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
    final dbPath = p.join(dbDir, AppConstants.mushafDatabaseName);

    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);

    return db;
  }
}