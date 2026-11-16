import 'package:material_ui/material_ui.dart';

import '../../constants/app_strings.dart';
import '../../theme/app_paddings.dart';
import '../../theme/app_spacing.dart';
import 'asset_database.dart';
import 'db_install_phase.dart';

/// Показывает [child] только когда все [databases] готовы, а до этого —
/// прогресс копирования или ошибку с кнопкой повтора.
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

  @override
  void initState() {
    super.initState();
    _installAll().ignore();
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
  Widget build(BuildContext context) {
    return Material(
      child: ListenableBuilder(
        listenable: _statuses,
        builder: (context, _) {
          final statuses = [
            for (final database in widget.databases) database.status.value,
          ];
          final count = statuses.length;
          final copyingIndex = statuses.indexWhere(
                (s) => s.phase == DbInstallPhase.copying,
          );
          if (copyingIndex != -1) {
            final progress = statuses[copyingIndex].progress;
            final prefix = count > 1 ? AppStrings.databaseOfCount(copyingIndex + 1, count) : '';
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
          }

          if (statuses.any((s) => s.phase == DbInstallPhase.failed)) {
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

          if (statuses.every((s) => s.phase == DbInstallPhase.ready)) {
            return widget.child;
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
