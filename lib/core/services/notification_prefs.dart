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
    required this.ikamahs,
    required this.ikamahMinutes,
    required this.events,
  });

  static const bool defaultPrayerEnabled = true;
  static const bool defaultIkamahEnabled = false;
  static const bool defaultEventEnabled = true;
  static const int fallbackIkamahMinutes = 15;

  static const defaultIkamahMinutes = <PrayerLabels, int>{
    PrayerLabels.fajr: 30,
    PrayerLabels.dhuhr: 15,
    PrayerLabels.asr: 15,
    PrayerLabels.maghrib: 12,
    PrayerLabels.isha: 15,
  };

  final Set<PrayerLabels> prayers;
  final Set<PrayerLabels> ikamahs;
  final Map<PrayerLabels, int> ikamahMinutes;
  final Set<NotificationEvent> events;

  bool get isEmpty => prayers.isEmpty && ikamahs.isEmpty && events.isEmpty;

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
      ikamahs: {
        for (final entry in NotificationKeys.ikamahEnabled.entries)
          if (read(entry.value, defaultIkamahEnabled)) entry.key,
      },
      ikamahMinutes: {
        for (final entry in NotificationKeys.ikamahMinutes.entries)
          entry.key: read(entry.value, defaultIkamahMinutes[entry.key] ?? fallbackIkamahMinutes),
      },
      events: {
        for (final entry in NotificationKeys.event.entries)
          if (read(entry.value, defaultEventEnabled)) entry.key,
      },
    );
  }
}