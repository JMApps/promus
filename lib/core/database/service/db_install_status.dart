import 'db_install_phase.dart';

class DbInstallStatus {
  const DbInstallStatus(
    this.phase, {
    this.copiedBytes = 0,
    this.totalBytes = 0,
    this.error,
  });

  final DbInstallPhase phase;
  final int copiedBytes;
  final int totalBytes;
  final Object? error;

  double? get progress => totalBytes > 0 ? copiedBytes / totalBytes : null;
}
