import 'dart:developer';
import 'dart:io';
import 'dart:math' show min;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'db_install_phase.dart';
import 'db_install_status.dart';

/// База данных, поставляемая в ассетах.
///
/// Работа в два шага:
/// 1. [ensureInstalled] — при старте: проверяет, скопирована ли база,
///    и копирует её, только если нет.
/// 2. [db] — там, где база нужна: просто открывает уже скопированный файл.
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

  /// Версия файла из ассетов. Увеличивается при каждой замене файла,
  /// чтобы после обновления приложения база скопировалась заново.
  final int version;

  static const int _chunkSize = 256 * 1024;

  final ValueNotifier<DbInstallStatus> _status = ValueNotifier(
    const DbInstallStatus(DbInstallPhase.idle),
  );

  ValueListenable<DbInstallStatus> get status => _status;

  bool _installed = false;
  Future<void>? _installing;

  Database? _db;
  Future<Database>? _opening;

  // ---------------------------------------------------------------------------
  // Шаг 1. Проверка и копирование
  // ---------------------------------------------------------------------------

  /// Если база уже скопирована (и её версия совпадает) — ничего не делает.
  /// Если нет — копирует из ассетов.
  ///
  /// Безопасно вызывать сколько угодно раз и из разных мест:
  /// параллельные вызовы ждут одно и то же копирование.
  Future<void> ensureInstalled() {
    if (_installed) return Future.value();
    return _installing ??= _ensureInstalled().whenComplete(
          () => _installing = null,
    );
  }

  Future<void> _ensureInstalled() async {
    try {
      final path = await _path();
      if (!await _isInstalled(path)) {
        await _copyFromAssets(path);
      }
      _installed = true;
      _status.value = const DbInstallStatus(DbInstallPhase.ready);
    } catch (e, s) {
      log('Database install failed: $fileName', error: e, stackTrace: s);
      _status.value = DbInstallStatus(DbInstallPhase.failed, error: e);
      rethrow;
    }
  }

  Future<bool> _isInstalled(String path) async {
    try {
      final marker = File('$path.version');
      if (!await marker.exists() || !await File(path).exists()) return false;
      return int.tryParse((await marker.readAsString()).trim()) == version;
    } catch (_) {
      return false;
    }
  }

  Future<void> _copyFromAssets(String path) async {
    _status.value = const DbInstallStatus(DbInstallPhase.copying);

    final marker = File('$path.version');
    final tmp = File('$path.tmp');

    try {
      if (await marker.exists()) await marker.delete();

      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final total = bytes.length;

      await Directory(p.dirname(path)).create(recursive: true);

      final raf = await tmp.open(mode: FileMode.write);
      try {
        for (var offset = 0; offset < total; offset += _chunkSize) {
          final end = min(offset + _chunkSize, total);
          await raf.writeFrom(bytes, offset, end);
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

      // Старую версию (если была) удаляем, новую ставим на её место.
      // Маркер пишем последним: если процесс прервётся раньше,
      // при следующем запуске база скопируется заново.
      await deleteDatabase(path);
      await tmp.rename(path);
      await marker.writeAsString('$version', flush: true);
    } catch (_) {
      try {
        if (await tmp.exists()) await tmp.delete();
      } catch (_) {}
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Шаг 2. Открытие
  // ---------------------------------------------------------------------------

  /// Открытая база. Первое обращение открывает файл, следующие
  /// возвращают то же соединение.
  ///
  /// Если [ensureInstalled] ещё не завершился (например, экран открылся
  /// раньше, чем закончилось копирование), сначала дождётся его.
  Future<Database> get db {
    final existing = _db;
    if (existing != null && existing.isOpen) return Future.value(existing);
    return _opening ??= _open().whenComplete(() => _opening = null);
  }

  Future<Database> _open() async {
    await ensureInstalled();
    final database = await openDatabase(
      await _path(),
      readOnly: true,
      singleInstance: true,
    );
    _db = database;
    return database;
  }

  /// Закрывает соединение. Следующее обращение к [db] откроет его снова.
  Future<void> close() async {
    final opening = _opening;
    if (opening != null) {
      try {
        await opening;
      } catch (_) {}
    }
    final database = _db;
    _db = null;
    if (database != null && database.isOpen) await database.close();
  }

  Future<String> _path() async => p.join(await getDatabasesPath(), fileName);
}