import 'package:material_ui/material_ui.dart';

import '../../constants/app_strings.dart';
import '../../theme/app_paddings.dart';
import '../../theme/app_spacing.dart';
import 'asset_database.dart';
import 'db_install_phase.dart';

/// Показывает [child] только когда все [databases] готовы, а до этого —
/// прогресс копирования или ошибку с кнопкой повтора.
///
/// Пока не ясно, что показывать (идёт проверка установленных баз),
/// первый кадр откладывается и пользователь видит нативный сплэш.
///
/// Базы копируются по очереди: `rootBundle` читает файл целиком в память,
/// и параллельное копирование нескольких больших файлов съело бы много RAM.
class DatabaseGate extends StatefulWidget {
  const DatabaseGate({
    super.key,
    required this.databases,
    required this.child,
  });

  final List<AssetDatabase> databases;
  final Widget child;

  @override
  State<DatabaseGate> createState() => _DatabaseGateState();
}

class _DatabaseGateState extends State<DatabaseGate> {
  late final Listenable _statuses = Listenable.merge([
    for (final database in widget.databases) database.status,
  ]);

  bool _firstFrameAllowed = false;

  @override
  void initState() {
    super.initState();
    // Держим нативный сплэш, пока не станет ясно, что показывать:
    // готовое приложение, прогресс копирования или ошибку.
    WidgetsBinding.instance.deferFirstFrame();
    _statuses.addListener(_allowFirstFrameIfResolved);
    _installAll().ignore();
    _allowFirstFrameIfResolved();
  }

  void _allowFirstFrameIfResolved() {
    if (_firstFrameAllowed) return;
    final phases = [
      for (final database in widget.databases) database.status.value.phase,
    ];
    final resolved = phases.contains(DbInstallPhase.copying) || phases.contains(DbInstallPhase.failed) || phases.every((p) => p == DbInstallPhase.ready);
    if (!resolved) return;
    _firstFrameAllowed = true;
    _statuses.removeListener(_allowFirstFrameIfResolved);
    WidgetsBinding.instance.allowFirstFrame();
  }

  Future<void> _installAll() async {
    for (final database in widget.databases) {
      try {
        await database.ensureInstalled();
      } catch (_) {
        // Ошибка уже в database.status; продолжаем со следующей базой.
      }
    }
  }

  Future<void> _retryFailed() async {
    for (final database in widget.databases) {
      if (database.status.value.phase != DbInstallPhase.failed) continue;
      try {
        await database.ensureInstalled();
      } catch (_) {
        // Ошибка снова попадёт в database.status.
      }
    }
  }

  @override
  void dispose() {
    if (!_firstFrameAllowed) {
      _statuses.removeListener(_allowFirstFrameIfResolved);
      WidgetsBinding.instance.allowFirstFrame();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListenableBuilder(
        listenable: _statuses,
        builder: (context, _) {
          final statuses = [
            for (final database in widget.databases) database.status.value,
          ];
          if (statuses.every((s) => s.phase == DbInstallPhase.ready)) {
            return widget.child;
          }
          final count = statuses.length;
          final copyingIndex = statuses.indexWhere(
                (s) => s.phase == DbInstallPhase.copying,
          );
          if (copyingIndex == -1 && statuses.any((s) => s.phase == DbInstallPhase.failed)) {
            return Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  const Text(AppStrings.databaseFailed),
                  const SizedBox(height: AppSpacing.medium),
                  FilledButton(
                    onPressed: () => _retryFailed().ignore(),
                    child: const Text(AppStrings.databaseRetry),
                  ),
                ],
              ),
            );
          }

          // Копирование или короткая пауза между базами (проверка следующей).
          final progress =
          copyingIndex == -1 ? null : statuses[copyingIndex].progress;
          final prefix = count > 1 && copyingIndex != -1 ? AppStrings.databaseOfCount(copyingIndex + 1, count) : '';
          return Center(
            child: Padding(
              padding: AppPaddings.hrMedium,
              child: Column(
                mainAxisSize: .min,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    prefix + (progress == null ? AppStrings.databasePreparing : AppStrings.databaseCopying((progress * 100).round())),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}