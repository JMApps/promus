import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/enums/counter_mode.dart';

class MainCounterState extends ChangeNotifier with WidgetsBindingObserver {
  MainCounterState({required this._box}) {
    _loadValues();
    WidgetsBinding.instance.addObserver(this);
  }

  static const _saveDelay = Duration(milliseconds: 400);

  final Box _box;
  final Map<CounterMode, int> _values = {};
  final Map<String, Object> _pending = {};
  late final Future<bool> _canVibrate = _detectVibrator();

  Timer? _saveTimer;
  CounterMode _mode = CounterMode.free;
  bool _tacticFeedback = true;
  bool _countLabelVisible = true;
  bool _disposed = false;

  CounterMode get mode => _mode;

  bool get tacticFeedback => _tacticFeedback;

  bool get countLabelVisible => _countLabelVisible;

  int get currentCount => _values[_mode]!;

  void changeMode(CounterMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    _save(AppConstants.keyCounterMode, newMode.name);
    notifyListeners();
  }

  void onCountClick() {
    final mode = _mode;
    final current = _values[mode]!;

    if (mode.countsDown && current == 0) {
      unawaited(_vibrateOnFinish());
      return;
    }

    final next = mode.countsDown ? current - 1 : current + 1;
    _update(mode, next);

    if (!_tacticFeedback) return;
    if (mode.countsDown && next == 0) {
      unawaited(_vibrateOnFinish());
    } else {
      unawaited(HapticFeedback.selectionClick());
    }
  }

  int? resetCurrent() {
    final mode = _mode;
    final previous = _values[mode]!;
    if (previous == mode.initialValue) return null;

    _update(mode, mode.initialValue);
    return previous;
  }

  void setValue(CounterMode mode, int value) => _update(mode, value);

  void toggleTacticFeedback() {
    _tacticFeedback = !_tacticFeedback;
    _save(AppConstants.keyCountFeetbackState, _tacticFeedback);
    notifyListeners();
  }

  void toggleCountLabel() {
    _countLabelVisible = !_countLabelVisible;
    _save(AppConstants.keyCountLabelIsShow, _countLabelVisible);
    notifyListeners();
  }

  void _loadValues() {
    _tacticFeedback = _read(AppConstants.keyCountFeetbackState, true);
    _countLabelVisible = _read(AppConstants.keyCountLabelIsShow, true);
    _mode = CounterMode.values.asNameMap()[_box.get(AppConstants.keyCounterMode)] ??
        CounterMode.free;

    for (final mode in CounterMode.values) {
      _values[mode] = _read(mode.storageKey, mode.initialValue);
    }
  }

  T _read<T>(String key, T fallback) {
    final value = _box.get(key);
    return value is T ? value : fallback;
  }

  void _update(CounterMode mode, int value) {
    _values[mode] = value;
    _save(mode.storageKey, value);
    notifyListeners();
  }

  void _save(String key, Object value) {
    _pending[key] = value;
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDelay, flush);
  }

  Future<void> flush() async {
    _saveTimer?.cancel();
    if (_pending.isEmpty) return;

    final batch = Map<String, Object>.of(_pending);
    _pending.clear();
    try {
      await _box.putAll(batch);
    } catch (e, st) {
      debugPrint('MainCounterState: не удалось сохранить $batch: $e\n$st');
    }
  }

  Future<bool> _detectVibrator() async {
    try {
      return await Vibration.hasVibrator() == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _vibrateOnFinish() async {
    if (!_tacticFeedback) return;
    try {
      if (await _canVibrate) {
        await Vibration.vibrate(pattern: const [0, 80, 70, 160]);
      } else {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      debugPrint('MainCounterState: ошибка вибрации: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(flush());
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(flush());
    super.dispose();
  }
}