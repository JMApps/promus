import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../constants/notification_keys.dart';
import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

/// Снимок настроек уведомлений на момент синхронизации.
///
/// Здесь единственное место со значениями по умолчанию:
/// их же использует NotificationSettingsState, чтобы экран
/// и планировщик никогда не расходились.
@immutable
class NotificationPrefs {
  const NotificationPrefs({
    required this.prayers,
    required this.iqamahs,
    required this.iqamahMinutes,
    required this.events,
  });

  static const bool defaultPrayerEnabled = true;
  static const bool defaultIqamahEnabled = false;
  static const bool defaultEventEnabled = true;
  static const int fallbackIqamahMinutes = 15;

  static const defaultIqamahMinutes = <PrayerLabels, int>{
    PrayerLabels.fajr: 30,
    PrayerLabels.dhuhr: 15,
    PrayerLabels.asr: 15,
    PrayerLabels.maghrib: 12,
    PrayerLabels.isha: 15,
  };

  final Set<PrayerLabels> prayers;
  final Set<PrayerLabels> iqamahs;
  final Map<PrayerLabels, int> iqamahMinutes;
  final Set<NotificationEvent> events;

  bool get isEmpty => prayers.isEmpty && iqamahs.isEmpty && events.isEmpty;

  factory NotificationPrefs.fromBox(Box box) {
    T read<T>(String key, T defaultValue) {
      final value = box.get(key);
      return value is T ? value : defaultValue;
    }

    return NotificationPrefs(
      prayers: {
        for (final entry in NotificationKeys.prayer.entries)
          if (read(entry.value, defaultPrayerEnabled)) entry.key,
      },
      iqamahs: {
        for (final entry in NotificationKeys.iqamahEnabled.entries)
          if (read(entry.value, defaultIqamahEnabled)) entry.key,
      },
      iqamahMinutes: {
        for (final entry in NotificationKeys.iqamahMinutes.entries)
          entry.key: read(entry.value, defaultIqamahMinutes[entry.key] ?? fallbackIqamahMinutes),
      },
      events: {
        for (final entry in NotificationKeys.event.entries)
          if (read(entry.value, defaultEventEnabled)) entry.key,
      },
    );
  }
}