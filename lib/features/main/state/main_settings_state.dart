import 'dart:async';

import 'package:hive_ce/hive_ce.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/constants/app_setting_keys.dart';

class MainSettingsState extends ChangeNotifier {
  MainSettingsState({required this._mainAppSettingsBox}) {
    _load();
    if (_alwaysOnDisplay) _applyWakeLock();
  }

  final Box _mainAppSettingsBox;

  ThemeMode _themeMode = .system;
  Color _themeColor = AppSettingKeys.defaultThemeColor;
  bool _alwaysOnDisplay = true;

  ThemeMode get themeMode => _themeMode;

  Color get themeColor => _themeColor;

  bool get alwaysOnDisplay => _alwaysOnDisplay;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    unawaited(_persist(AppSettingKeys.keyThemeMode, mode.name));
    notifyListeners();
  }

  void setThemeColor(Color color) {
    if (_themeColor == color) return;
    _themeColor = color;
    unawaited(_persist(AppSettingKeys.keyThemeColor, color.toARGB32()));
    notifyListeners();
  }

  void setAlwaysOnDisplay(bool value) {
    if (_alwaysOnDisplay == value) return;
    _alwaysOnDisplay = value;
    unawaited(_persist(AppSettingKeys.keyAlwaysOnDisplay, value));
    _applyWakeLock();
    notifyListeners();
  }

  void _load() {
    _themeMode =
        ThemeMode.values.asNameMap()[_mainAppSettingsBox.get(
          AppSettingKeys.keyThemeMode,
        )] ??
        ThemeMode.system;
    _alwaysOnDisplay = _read(AppSettingKeys.keyAlwaysOnDisplay, true);

    final storedColor = _read<int?>(AppSettingKeys.keyThemeColor, null);
    if (storedColor != null) _themeColor = Color(storedColor);
  }

  T _read<T>(String key, T fallback) {
    final value = _mainAppSettingsBox.get(key);
    return value is T ? value : fallback;
  }

  Future<void> _persist(String key, Object value) async {
    try {
      await _mainAppSettingsBox.put(key, value);
    } catch (e, st) {
      debugPrint('MainSettingsState: не удалось сохранить $key: $e\n$st');
    }
  }

  void _applyWakeLock() {
    unawaited(
      WakelockPlus.toggle(enable: _alwaysOnDisplay).catchError(
        (Object e) => debugPrint('MainSettingsState: wakelock: $e'),
      ),
    );
  }
}
