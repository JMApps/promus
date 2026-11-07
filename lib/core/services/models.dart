import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

/// Канал уведомления: от него зависят звук, важность и режим будильника.
enum NotificationChannelKind { prayer, ikamah, reminder }

/// Времена намазов на один календарный день.
///
/// Значения — абсолютные моменты времени (adhan отдаёт UTC, это нормально).
typedef DayPrayerTimes = Map<PrayerLabels, DateTime>;

/// Источник времён намазов, «замороженный» на момент синхронизации:
/// город и параметры расчёта уже подставлены внутрь.
abstract interface class PrayerTimesSource {
  /// Времена на календарную дату [localDate] (важны только год, месяц и день).
  /// Вернуть `null`, если на эту дату посчитать нельзя.
  DayPrayerTimes? timesFor(DateTime localDate);
}

@immutable
class HijriDate {
  const HijriDate({required this.year, required this.month, required this.day});

  final int year;
  final int month;
  final int day;
}

/// Перевод григорианской даты в хиджру с учётом пользовательского смещения.
typedef HijriResolver = HijriDate Function(DateTime localDate);

/// Одно уведомление из плана.
@immutable
class PlannedNotification {
  const PlannedNotification({
    required this.id,
    required this.channel,
    required this.at,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final NotificationChannelKind channel;
  final DateTime at;
  final String title;
  final String body;
  final String payload;
}

/// Детерминированные id: одно и то же событие всегда получает один и тот же номер.
///
/// `id = dayKey * 32 + slot`, где dayKey — число дней с 2020-01-01
/// по календарной дате срабатывания.
abstract final class NotificationIds {
  static final DateTime _epoch = DateTime.utc(2020);
  static const int _slotsPerDay = 32;

  static const int openAppSlot = 31;

  static int dayKey(DateTime localDate) =>
      DateTime.utc(localDate.year, localDate.month, localDate.day).difference(_epoch).inDays;

  static int forDay(DateTime localDate, int slot) {
    assert(slot >= 0 && slot < _slotsPerDay, 'slot $slot');
    return dayKey(localDate) * _slotsPerDay + slot;
  }

  /// 0–5: fajr, sunrise, dhuhr, asr, maghrib, isha.
  static int prayerSlot(PrayerLabels p) => p.index;

  /// 8–13 (слот восхода не используется).
  static int ikamahSlot(PrayerLabels p) => 8 + p.index;

  static int eventSlot(NotificationEvent e) => switch (e) {
    NotificationEvent.friday => 16,
    NotificationEvent.fridayLastHour => 17,
    NotificationEvent.fastMonday => 18,
    NotificationEvent.fastThursday => 19,
    NotificationEvent.fastWhiteDays => 20,
  };
}

enum NotificationPayloadType { prayer, ikamah, event, openApp }

/// Payload запланированного уведомления.
///
/// Нужен для двух вещей:
/// 1. понять при сравнении, совпадает ли уже запланированное с нужным
///    (`pendingNotificationRequests()` не отдаёт дату срабатывания);
/// 2. открыть нужный экран по нажатию (`onTap` / `getLaunchPayload`).
@immutable
class NotificationPayload {
  const NotificationPayload({
    required this.type,
    required this.key,
    required this.at,
    required this.exact,
  });

  /// Версия формата. По ней планировщик узнаёт «свои» уведомления
  /// и не трогает чужие (если в приложении появятся другие).
  static const int _format = 1;

  final NotificationPayloadType type;

  /// Имя намаза (`fajr`) или события (`fastMonday`).
  final String key;

  final DateTime at;

  /// Запланировано ли точным будильником. Если пользователь позже выдаст
  /// разрешение на точные будильники, payload изменится и всё перепланируется.
  final bool exact;

  String encode() => jsonEncode({
    's': _format,
    't': type.name,
    'k': key,
    'at': at.millisecondsSinceEpoch,
    'x': exact ? 1 : 0,
  });

  static NotificationPayload? tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map<String, dynamic> || map['s'] != _format) return null;

      final type = NotificationPayloadType.values.asNameMap()[map['t']];
      final at = map['at'];
      final key = map['k'];
      if (type == null || at is! int) return null;

      return NotificationPayload(
        type: type,
        key: key is String ? key : '',
        at: DateTime.fromMillisecondsSinceEpoch(at),
        exact: map['x'] == 1,
      );
    } on FormatException {
      return null;
    }
  }
}