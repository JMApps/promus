import 'dart:developer';
import 'dart:io';
import 'dart:math' show min;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'db_install_phase.dart';
import 'db_install_status.dart';

class AssetDatabase {
  AssetDatabase({
    required this.assetPath,
    required this.fileName,
    required this.version,
  });

  /// Ключ файла в ассетах, например `assets/databases/mushaf.db`.
  final String assetPath;

  /// Имя файла базы на устройстве.
  final String fileName;

  /// Версия файла из ассетов. Увеличивается при каждой замене файла.
  final int version;

  static const int _chunkSize = 256 * 1024;

  final ValueNotifier<DbInstallStatus> _status = ValueNotifier(
    const DbInstallStatus(DbInstallPhase.idle),
  );

  Database? _db;
  Future<Database>? _opening;

  ValueListenable<DbInstallStatus> get status => _status;

  Future<Database> get db {
    final opening = _opening;
    if (opening != null) return opening;

    final existing = _db;
    if (existing != null && existing.isOpen) {
      return Future.value(existing);
    }

    return _opening = _open();
  }

  /// Открывает базу, только если нужная версия уже установлена.
  /// Ничего не копирует, поэтому занимает миллисекунды.
  Future<void> openIfInstalled() async {
    if (_opening != null || (_db?.isOpen ?? false)) return;
    try {
      final dbPath = p.join(await getDatabasesPath(), fileName);
      if (!await _isInstalled(dbPath)) return;
      await db;
    } catch (_) {
      // Ошибка уже в status, её покажет DatabaseGate.
    }
  }

  /// Копирует базу из ассетов заново, даже если она уже установлена.
  Future<Database> reinstallFromAssets() async {
    while (_opening != null) {
      try {
        await _opening;
      } catch (_) {}
    }
    return _opening = _open(force: true);
  }

  /// Закрывает соединение. Следующее обращение к [db] откроет его снова.
  Future<void> close() async {
    while (_opening != null) {
      try {
        await _opening;
      } catch (_) {}
    }
    await _closeHandle();
  }

  Future<Database> _open({bool force = false}) async {
    try {
      final dbPath = p.join(await getDatabasesPath(), fileName);

      if (force || !await _isInstalled(dbPath)) {
        await _install(dbPath);
      }

      final database = await openDatabase(
        dbPath,
        readOnly: true,
        singleInstance: true,
      );

      _db = database;
      _status.value = const DbInstallStatus(DbInstallPhase.ready);
      return database;
    } catch (e, s) {
      log('Database open failed: $fileName', error: e, stackTrace: s);
      _status.value = DbInstallStatus(DbInstallPhase.failed, error: e);
      rethrow;
    } finally {
      _opening = null;
    }
  }

  Future<bool> _isInstalled(String dbPath) async {
    try {
      final marker = File('$dbPath.version');
      if (!await marker.exists() || !await File(dbPath).exists()) {
        return false;
      }
      return int.tryParse((await marker.readAsString()).trim()) == version;
    } catch (_) {
      return false;
    }
  }

  Future<void> _install(String dbPath) async {
    _status.value = const DbInstallStatus(DbInstallPhase.copying);

    final marker = File('$dbPath.version');
    final tmp = File('$dbPath.tmp');

    try {
      if (await marker.exists()) await marker.delete();

      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final total = bytes.length;

      await Directory(p.dirname(dbPath)).create(recursive: true);

      final raf = await tmp.open(mode: FileMode.write);
      try {
        for (var offset = 0; offset < total; offset += _chunkSize) {
          final end = min(offset + _chunkSize, total);
          await raf.writeFrom(bytes.sublist(offset, end));
          _status.value = DbInstallStatus(
            DbInstallPhase.copying,
            copiedBytes: end,
            totalBytes: total,
          );
        }
        await raf.flush();
      } finally {
        await raf.close();
      }

      await _closeHandle();
      await deleteDatabase(dbPath);
      await tmp.rename(dbPath);
      await marker.writeAsString('$version', flush: true);
    } catch (_) {
      try {
        if (await tmp.exists()) await tmp.delete();
      } catch (_) {}
      rethrow;
    }
  }

  Future<void> _closeHandle() async {
    final database = _db;
    _db = null;
    if (database != null && database.isOpen) {
      await database.close();
    }
  }
}
