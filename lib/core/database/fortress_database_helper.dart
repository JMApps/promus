import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class FortressDatabaseHelper {
  FortressDatabaseHelper._();

  static final FortressDatabaseHelper instance = FortressDatabaseHelper._();

  static const String _dbFileName = 'fortress_of_the_muslim.db';
  static const String _assetPath = 'assets/databases/$_dbFileName';

  /// Должна совпадать с `PRAGMA user_version` внутри файла в ассетах.
  /// Собрали новую базу — поднимите user_version в ней и эту константу.
  /// В debug-сборке расхождение падает по assert сразу после установки.
  static const int _expectedDbVersion = 3;

  /// Смещение поля user_version в заголовке SQLite (4 байта, big-endian).
  static const int _userVersionOffset = 60;

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

  Future<String> _resolveDbPath() async {
    final dbDir = await getDatabasesPath();
    return p.join(dbDir, _dbFileName);
  }

  // ---------------------------------------------------------------- установка

  Future<void> _ensureDatabaseInstalled(String dbPath) async {
    if (!await File(dbPath).exists()) {
      await _installFreshFromAssets(dbPath);
      return;
    }

    final state = await _probe(dbPath);

    if (state.valid && state.version == _expectedDbVersion) return;

    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);
  }

  /// Одно открытие вместо двух: проверяет читаемость и сразу отдаёт версию.
  Future<({bool valid, int version})> _probe(String dbPath) async {
    Database? probe;

    try {
      probe = await openDatabase(
        dbPath,
        singleInstance: false,
        readOnly: true,
      );

      await probe.rawQuery(
        'SELECT name FROM sqlite_master WHERE type = ? LIMIT 1',
        ['table'],
      );

      return (valid: true, version: await probe.getVersion());
    } catch (_) {
      return (valid: false, version: -1);
    } finally {
      await probe?.close();
    }
  }

  Future<void> _installFreshFromAssets(String dbPath) async {
    try {
      await _copyAssetDbTo(dbPath);

      // user_version уже записан внутри файла при сборке базы —
      // копия его сохраняет, setVersion() не нужен.
      if (kDebugMode) {
        final installed = await _probe(dbPath);
        assert(
        installed.valid && installed.version == _expectedDbVersion,
        'Файл в ассетах имеет user_version = ${installed.version}, '
            'а _expectedDbVersion = $_expectedDbVersion. '
            'Обновите константу или пересоберите базу.',
        );
      }
    } catch (e, s) {
      log('Fresh database install failed', error: e, stackTrace: s);
      await _deleteCopiedDatabase(dbPath);
      rethrow;
    }
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load(_assetPath);

    try {
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final file = File(dbPath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
    } finally {
      // rootBundle кэширует загруженное — иначе полмегабайта
      // будут висеть в памяти до конца жизни приложения.
      rootBundle.evict(_assetPath);
    }
  }

  Future<void> _deleteCopiedDatabase(String dbPath) async {
    // Внутренний сброс: НЕ трогает _opening, иначе параллельный вызов
    // геттера db запустит вторую установку поверх текущей.
    await _closeCurrent();

    if (await File(dbPath).exists()) {
      await deleteDatabase(dbPath);
    }
  }

  // ------------------------------------------------------------------ закрытие

  Future<void> _closeCurrent() async {
    final database = _db;
    _db = null;

    if (database != null && database.isOpen) {
      await database.close();
    }
  }

  Future<void> close() async {
    _opening = null;
    await _closeCurrent();
  }

  Future<Database> reinstallFromAssets() async {
    await close();

    final dbPath = await _resolveDbPath();
    await _deleteCopiedDatabase(dbPath);
    await _installFreshFromAssets(dbPath);

    return db;
  }

  /// Версия файла в ассетах, прочитанная прямо из заголовка SQLite.
  /// Нужна только для диагностики — в обычном потоке не вызывается.
  Future<int> readAssetVersion() async {
    final data = await rootBundle.load(_assetPath);
    try {
      return data.getUint32(_userVersionOffset);
    } finally {
      rootBundle.evict(_assetPath);
    }
  }
}