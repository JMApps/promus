import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:promus/core/constants/app_constants.dart';
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
    return p.join(dbDir, AppConstants.mushafDatabaseName);
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
    if (await File(dbPath).exists() && await _isInstalledAndCurrent(dbPath)) {
      return;
    }

    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);
  }

  /// Одна проба: файл открывается, версия актуальна, обе FTS-таблицы на месте.
  Future<bool> _isInstalledAndCurrent(String dbPath) async {
    Database? probe;

    try {
      probe = await openDatabase(
        dbPath,
        singleInstance: false,
        readOnly: true,
      );

      final version = await probe.getVersion();
      if (version != _dbVersion) return false;

      final rows = await probe.rawQuery(
        '''
        SELECT COUNT(*) AS c
        FROM sqlite_master
        WHERE name IN (?, ?)
        ''',
        [TableNames.ftsArabicTable, TableNames.ftsTranslationsTable],
      );

      return (Sqflite.firstIntValue(rows) ?? 0) == 2;
    } catch (_) {
      return false;
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

      await rw.transaction((txn) async {
        await _createIndexes(txn);
        await _createFts(txn);
      });

      await rw.execute('ANALYZE');

      // Версия ставится ПОСЛЕДНЕЙ: если установка оборвётся,
      // при следующем запуске БД будет пересоздана.
      await rw.setVersion(_dbVersion);
    } catch (e, s) {
      log('Fresh database install failed', error: e, stackTrace: s);

      await rw?.close();
      rw = null;
      await _deleteCopiedDatabase(dbPath);

      rethrow;
    } finally {
      await rw?.close();
    }
  }

  Future<void> _createIndexes(Transaction txn) async {
    await txn.execute(
      '''
      CREATE INDEX IF NOT EXISTS idx_glyphs_surah_ayah
      ON Table_of_glyph(surah_number, ayah_number)
      ''',
    );

    await txn.execute(
      '''
      CREATE INDEX IF NOT EXISTS idx_glyphs_location
      ON Table_of_glyph(location)
      ''',
    );

    await txn.execute(
      '''
      CREATE INDEX IF NOT EXISTS idx_layout_page_line_words
      ON Table_of_layout(
        page_number,
        line_number,
        first_word_id,
        last_word_id
      )
      ''',
    );

    await txn.execute(
      '''
      CREATE INDEX IF NOT EXISTS idx_ayahs_page_position
      ON Table_of_ayah_by_ayah(ayah_page_number, ayah_position)
      ''',
    );

    await txn.execute(
      '''
      CREATE INDEX IF NOT EXISTS idx_ayahs_verse_key
      ON Table_of_ayah_by_ayah(verse_key)
      ''',
    );

    await txn.execute(
      '''
      CREATE INDEX IF NOT EXISTS idx_translations_ayah_key
      ON Table_of_translation(ayah_key)
      ''',
    );
  }

  Future<void> _createFts(Transaction txn) async {
    // ---------- Арабский ----------
    await txn.execute('DROP TABLE IF EXISTS ${TableNames.ftsArabicTable}');

    await txn.execute(
      '''
      CREATE VIRTUAL TABLE ${TableNames.ftsArabicTable}
      USING fts4(
        ayah_normalized,
        tokenize=unicode61,
        prefix="2,3"
      )
      ''',
    );

    await txn.execute(
      '''
      INSERT INTO ${TableNames.ftsArabicTable}(rowid, ayah_normalized)
      SELECT ayah_id, COALESCE(ayah_normalized, '')
      FROM Table_of_ayah_by_ayah
      ''',
    );

    await txn.execute(
      "INSERT INTO ${TableNames.ftsArabicTable}(${TableNames.ftsArabicTable}) VALUES('optimize')",
    );

    // ---------- Переводы ----------
    await txn.execute('DROP TABLE IF EXISTS ${TableNames.ftsTranslationsTable}');

    await txn.execute(
      '''
      CREATE VIRTUAL TABLE ${TableNames.ftsTranslationsTable}
      USING fts4(
        ayah_ru_kuliev,
        ayah_ru_adel,
        tokenize=unicode61,
        prefix="2,3"
      )
      ''',
    );

    await txn.execute(
      '''
      INSERT INTO ${TableNames.ftsTranslationsTable}(rowid, ayah_ru_kuliev, ayah_ru_adel)
      SELECT
        a.ayah_id,
        COALESCE(t.ayah_ru_kuliev, ''),
        COALESCE(t.ayah_ru_adel, '')
      FROM Table_of_ayah_by_ayah a
      JOIN Table_of_translation t ON t.ayah_key = a.verse_key
      ''',
    );

    await txn.execute(
      "INSERT INTO ${TableNames.ftsTranslationsTable}(${TableNames.ftsTranslationsTable}) VALUES('optimize')",
    );
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load(
      '${AppConstants.databasesPath}${AppConstants.mushafDatabaseName}',
    );

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
    final database = _db;
    _db = null;

    if (database != null && database.isOpen) {
      await database.close();
    }
  }

  Future<Database> reinstallFromAssets() async {
    // дождаться уже идущего открытия, чтобы не было двух параллельных установок
    final pending = _opening;
    if (pending != null) {
      try {
        await pending;
      } catch (_) {}
    }

    final dbPath = await _resolveDbPath();

    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);

    return db;
  }
}