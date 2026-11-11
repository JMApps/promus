
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/constants/notification_keys.dart';
import '../../../core/enums/notification_event.dart';
import '../../../core/enums/prayer_labels.dart';
import '../../../core/services/notification_prefs.dart';

/// Состояние экрана настроек уведомлений.
///
/// Планированием не занимается: NotificationScheduler сам слушает
/// этот box через `watch()` и перепланирует после любой записи.
class NotificationSettingsState extends ChangeNotifier {
  NotificationSettingsState({required this._mainNotificationsBox});

  final Box _mainNotificationsBox;

  bool prayerEnabled(PrayerLabels p) => _read(NotificationKeys.prayer[p]!, NotificationPrefs.defaultPrayerEnabled);

  bool iqamahEnabled(PrayerLabels p) {
    assert(p.hasIqamah, '$p');
    return _read(NotificationKeys.iqamahEnabled[p]!, NotificationPrefs.defaultIqamahEnabled);
  }

  int iqamahMinutes(PrayerLabels p) {
    assert(p.hasIqamah, '$p');
    return _read(
      NotificationKeys.iqamahMinutes[p]!,
      NotificationPrefs.defaultIqamahMinutes[p] ?? NotificationPrefs.fallbackIqamahMinutes,
    );
  }

  bool eventEnabled(NotificationEvent e) => _read(NotificationKeys.event[e]!, NotificationPrefs.defaultEventEnabled);

  Future<void> setPrayer(PrayerLabels p, bool v) => _write(NotificationKeys.prayer[p]!, v);

  Future<void> setIqamah(PrayerLabels p, bool v) {
    assert(p.hasIqamah, '$p');
    return _write(NotificationKeys.iqamahEnabled[p]!, v);
  }

  Future<void> setIqamahMinutes(PrayerLabels p, int m) {
    assert(p.hasIqamah, '$p');
    return _write(NotificationKeys.iqamahMinutes[p]!, m);
  }

  Future<void> setEvent(NotificationEvent e, bool v) => _write(NotificationKeys.event[e]!, v);

  T _read<T>(String key, T defaultValue) {
    final value = _mainNotificationsBox.get(key);
    return value is T ? value : defaultValue;
  }

  Future<void> defNotificationValues() async {
    final keys = NotificationKeys.allNotificationDefValues;
    if (!keys.any(_mainNotificationsBox.containsKey)) return;

    await _mainNotificationsBox.deleteAll(keys);
    notifyListeners();
  }

  Future<void> _write(String key, Object value) async {
    if (_mainNotificationsBox.get(key) == value) return;
    await _mainNotificationsBox.put(key, value);
    notifyListeners();
  }
}