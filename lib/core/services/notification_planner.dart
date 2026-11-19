import 'package:timezone/timezone.dart' as tz;

import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';
import '../utils/fasting_calendar.dart';
import 'models.dart';
import 'notification_prefs.dart';
import 'notification_texts.dart';

/// Строит список уведомлений «как должно быть».
///
/// Чистая логика без плагинов и платформенных вызовов: её легко покрыть тестами.
class NotificationPlanner {
  const NotificationPlanner({
    this.texts = const NotificationTexts(),
    this.fridayAfterSunrise = const Duration(minutes: 30),
    this.lastHourBeforeMaghrib = const Duration(hours: 1),
    this.fastReminderAfterMaghrib = const Duration(hours: 1),
  });

  final NotificationTexts texts;

  /// Пятничное напоминание: через сколько после восхода.
  final Duration fridayAfterSunrise;

  /// Последний час пятницы: за сколько до магриба (но не раньше аср).
  final Duration lastHourBeforeMaghrib;

  /// Напоминания о посте приходят накануне вечером: через сколько после магриба.
  final Duration fastReminderAfterMaghrib;

  /// [maxCount] — сколько всего уведомлений можно держать запланированными
  /// (на iOS система хранит максимум 64). Последнее место занимает
  /// напоминание «откройте приложение».
  ///
  /// [maxHorizonDays] — сколько дней вперёд смотреть. Чем меньше типов
  /// уведомлений включено, тем дальше вперёд хватит [maxCount].
  List<PlannedNotification> build({
    required DateTime now,
    required NotificationPrefs prefs,
    required PrayerTimesSource times,
    required HijriResolver hijri,
    required bool exact,
    required int maxCount,
    required int maxHorizonDays,
    String Function(DateTime at)? formatTime,
  }) {
    if (prefs.isEmpty || maxCount < 2) return const [];

    // Формат времени пользователя (12/24 ч). По умолчанию — ЧЧ:ММ.
    final fmt = formatTime ?? texts.formatTime;

    final localNow = tz.TZDateTime.from(now, tz.local);
    final today = DateTime(localNow.year, localNow.month, localNow.day);
    final notBefore = now.add(const Duration(seconds: 10));
    final items = <PlannedNotification>[];

    void add({
      required DateTime date,
      required int slot,
      required NotificationChannelKind channel,
      required DateTime at,
      required String title,
      required String body,
      required NotificationPayloadType type,
      required String key,
    }) {
      if (!at.isAfter(notBefore)) return;
      items.add(
        PlannedNotification(
          id: NotificationIds.forDay(date, slot),
          channel: channel,
          at: at,
          title: title,
          body: body,
          payload: NotificationPayload(
            type: type,
            key: key,
            at: at,
            exact: exact,
          ).encode(),
        ),
      );
    }

    void addEvent(
      DateTime date,
      NotificationEvent e,
      DateTime at, {
      int? hijriMonth,
    }) {
      if (!prefs.events.contains(e)) return;
      add(
        date: date,
        slot: NotificationIds.eventSlot(e),
        channel: NotificationChannelKind.reminder,
        at: at,
        title: texts.eventTitle(e),
        body: texts.eventBody(e, hijriMonth: hijriMonth),
        type: NotificationPayloadType.event,
        key: e.name,
      );
    }

    for (var d = 0; d < maxHorizonDays; d++) {
      final date = DateTime(today.year, today.month, today.day + d);
      final t = times.timesFor(date);
      if (t == null) continue;

      // Намазы и икамы.
      for (final p in PrayerLabels.values) {
        final at = t[p];
        if (at == null) continue;

        if (prefs.prayers.contains(p)) {
          add(
            date: date,
            slot: NotificationIds.prayerSlot(p),
            // У восхода нет азана — обычный звук напоминания.
            channel: p == PrayerLabels.sunrise
                ? NotificationChannelKind.reminder
                : NotificationChannelKind.prayer,
            at: at,
            title: texts.prayerTitle(p, fmt(at)),
            body: texts.prayerBody(p),
            type: NotificationPayloadType.prayer,
            key: p.name,
          );
        }

        if (p.hasIqamah && prefs.iqamahs.contains(p)) {
          final minutes =
              prefs.iqamahMinutes[p] ?? NotificationPrefs.fallbackIqamahMinutes;
          final iqamahAt = at.add(Duration(minutes: minutes));
          add(
            date: date,
            slot: NotificationIds.iqamahSlot(p),
            channel: NotificationChannelKind.iqamah,
            at: iqamahAt,
            title: texts.iqamahTitle(p, fmt(iqamahAt)),
            body: texts.iqamahBody(p),
            type: NotificationPayloadType.iqamah,
            key: p.name,
          );
        }
      }

      final sunrise = t[PrayerLabels.sunrise];
      final asr = t[PrayerLabels.asr];
      final maghrib = t[PrayerLabels.maghrib];

      // Пятница.
      if (date.weekday == DateTime.friday) {
        if (sunrise != null) {
          addEvent(
            date,
            NotificationEvent.friday,
            sunrise.add(fridayAfterSunrise),
          );
        }
        if (maghrib != null) {
          var lastHour = maghrib.subtract(lastHourBeforeMaghrib);
          if (asr != null && lastHour.isBefore(asr)) lastHour = asr;
          addEvent(date, NotificationEvent.fridayLastHour, lastHour);
        }
      }

      // Посты: напоминание накануне вечером о завтрашнем дне.
      if (maghrib != null) {
        final eveningAt = maghrib.add(fastReminderAfterMaghrib);
        final tomorrow = DateTime(date.year, date.month, date.day + 1);
        final h = hijri(tomorrow);

        // Рамадан, оба Ида и дни ташрик: о добровольном посте не напоминаем.
        if (!FastingCalendar.isVoluntaryFastReminderBlocked(h)) {
          // Если завтра начинаются белые дни, одного напоминания достаточно:
          // не шлём вдобавок «завтра понедельник» в тот же вечер.
          final whiteDays =
              prefs.events.contains(NotificationEvent.fastWhiteDays) &&
              FastingCalendar.isWhiteDaysStart(h);
          if (whiteDays) {
            addEvent(
              date,
              NotificationEvent.fastWhiteDays,
              eveningAt,
              hijriMonth: h.month,
            );
          } else if (tomorrow.weekday == DateTime.monday) {
            addEvent(date, NotificationEvent.fastMonday, eveningAt);
          } else if (tomorrow.weekday == DateTime.thursday) {
            addEvent(date, NotificationEvent.fastThursday, eveningAt);
          }
        }
      }

      // Дни идут по порядку: если лимит уже набран, дальше смотреть незачем.
      if (items.length >= maxCount) break;
    }

    if (items.isEmpty) return items;

    items.sort((a, b) => a.at.compareTo(b.at));
    final result = items.length >= maxCount
        ? items.sublist(0, maxCount - 1)
        : items;

    // Последнее уведомление окна: просьба открыть приложение.
    // Если приложение откроют раньше, окно продлится, и это напоминание
    // переедет дальше само.
    final openAt = result.last.at.add(const Duration(minutes: 1));
    final openLocal = tz.TZDateTime.from(openAt, tz.local);
    result.add(
      PlannedNotification(
        id: NotificationIds.forDay(
          DateTime(openLocal.year, openLocal.month, openLocal.day),
          NotificationIds.openAppSlot,
        ),
        channel: NotificationChannelKind.reminder,
        at: openAt,
        title: texts.openAppTitle,
        body: texts.openAppBody,
        payload: NotificationPayload(
          type: NotificationPayloadType.openApp,
          key: 'open_app',
          at: openAt,
          exact: exact,
        ).encode(),
      ),
    );

    return result;
  }
}
