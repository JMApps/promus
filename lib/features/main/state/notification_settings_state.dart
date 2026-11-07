
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

  bool ikamahEnabled(PrayerLabels p) {
    assert(p.hasIkamah, '$p');
    return _read(NotificationKeys.ikamahEnabled[p]!, NotificationPrefs.defaultIkamahEnabled);
  }

  int ikamahMinutes(PrayerLabels p) {
    assert(p.hasIkamah, '$p');
    return _read(
      NotificationKeys.ikamahMinutes[p]!,
      NotificationPrefs.defaultIkamahMinutes[p] ?? NotificationPrefs.fallbackIkamahMinutes,
    );
  }

  bool eventEnabled(NotificationEvent e) => _read(NotificationKeys.event[e]!, NotificationPrefs.defaultEventEnabled);

  Future<void> setPrayer(PrayerLabels p, bool v) => _write(NotificationKeys.prayer[p]!, v);

  Future<void> setIkamah(PrayerLabels p, bool v) {
    assert(p.hasIkamah, '$p');
    return _write(NotificationKeys.ikamahEnabled[p]!, v);
  }

  Future<void> setIkamahMinutes(PrayerLabels p, int m) {
    assert(p.hasIkamah, '$p');
    return _write(NotificationKeys.ikamahMinutes[p]!, m);
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