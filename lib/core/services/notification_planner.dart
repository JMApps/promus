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
    this.duhaAfterSunrise = const Duration(minutes: 45),
    this.morningAdhkarAfterFajr = const Duration(minutes: 45),
    this.eveningAdhkarAfterAsr = const Duration(minutes: 30),
    this.sleepAdhkarAfterIsha = const Duration(minutes: 45),
    this.fridayEveAfterMaghrib = const Duration(hours: 1),
    this.lastHourBeforeMaghrib = const Duration(hours: 1),
    this.fastReminderAfterMaghrib = const Duration(hours: 1),
    this.whiteDaysAfterAsr = const Duration(hours: 1),
  });

  /// Ад-Духа: через сколько после восхода.
  final Duration duhaAfterSunrise;

  /// Утренние азкары: через сколько после фаджра.
  final Duration morningAdhkarAfterFajr;

  /// Вечерние азкары: через сколько после 'асра.
  final Duration eveningAdhkarAfterAsr;

  /// Азкары перед сном: через сколько после 'иши.
  final Duration sleepAdhkarAfterIsha;

  /// «Завтра пятница» (в четверг): через сколько после магриба.
  final Duration fridayEveAfterMaghrib;

  /// Последний час пятницы: за сколько до магриба (но не раньше 'асра).
  final Duration lastHourBeforeMaghrib;

  /// «Завтра день желательного поста» (в воскресенье и среду): через сколько после магриба.
  final Duration fastReminderAfterMaghrib;

  /// «Завтра начинаются белые дни» (12-го числа): через сколько после 'асра.
  final Duration whiteDaysAfterAsr;

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
  }) {
    if (prefs.isEmpty || maxCount < 2) return const [];

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

    void addEvent(DateTime date, NotificationEvent e, DateTime? at) {
      if (at == null || !prefs.events.contains(e)) return;
      add(
        date: date,
        slot: NotificationIds.eventSlot(e),
        channel: NotificationChannelKind.reminder,
        at: at,
        title: NotificationTexts.eventTitles[e]!,
        body: NotificationTexts.eventBodies[e]!,
        type: NotificationPayloadType.event,
        key: e.name,
      );
    }

    for (var d = 0; d < maxHorizonDays; d++) {
      final date = DateTime(today.year, today.month, today.day + d);
      final t = times.timesFor(date);
      if (t == null) continue;

      // Намазы и икамы (восход сюда не входит: о нём отдельного уведомления нет).
      for (final p in PrayerLabels.withIqamah) {
        final at = t[p];
        if (at == null) continue;

        if (prefs.prayers.contains(p)) {
          add(
            date: date,
            slot: NotificationIds.prayerSlot(p),
            channel: NotificationChannelKind.prayer,
            at: at,
            title: NotificationTexts.prayerTitle,
            body: NotificationTexts.prayerBodies[p]!,
            type: NotificationPayloadType.prayer,
            key: p.name,
          );
        }

        if (prefs.iqamahs.contains(p)) {
          final minutes = prefs.iqamahMinutes[p] ?? NotificationPrefs.fallbackIqamahMinutes;
          add(
            date: date,
            slot: NotificationIds.iqamahSlot(p),
            channel: NotificationChannelKind.iqamah,
            at: at.add(Duration(minutes: minutes)),
            title: NotificationTexts.iqamahTitle,
            body: NotificationTexts.iqamahBodies[p]!,
            type: NotificationPayloadType.iqamah,
            key: p.name,
          );
        }
      }

      final fajr = t[PrayerLabels.fajr];
      final sunrise = t[PrayerLabels.sunrise];
      final asr = t[PrayerLabels.asr];
      final maghrib = t[PrayerLabels.maghrib];
      final isha = t[PrayerLabels.isha];

      // Каждый день: Ад-Духа и азкары.
      addEvent(date, NotificationEvent.duha, sunrise?.add(duhaAfterSunrise));
      addEvent(date, NotificationEvent.morningAdhkar, fajr?.add(morningAdhkarAfterFajr));
      addEvent(date, NotificationEvent.eveningAdhkar, asr?.add(eveningAdhkarAfterAsr));
      addEvent(date, NotificationEvent.sleepAdhkar, isha?.add(sleepAdhkarAfterIsha));

      // Пятница.
      if (date.weekday == DateTime.thursday) {
        addEvent(date, NotificationEvent.fridayEve, maghrib?.add(fridayEveAfterMaghrib));
      }
      if (date.weekday == DateTime.friday && maghrib != null) {
        var lastHour = maghrib.subtract(lastHourBeforeMaghrib);
        if (asr != null && lastHour.isBefore(asr)) lastHour = asr;
        addEvent(date, NotificationEvent.fridayLastHour, lastHour);
      }

      // Посты: напоминание накануне о завтрашнем дне. Не напоминаем, если
      // завтра Рамадан, Ид, дни ташрик или 'Ашура.
      final tomorrow = DateTime(date.year, date.month, date.day + 1);
      final h = hijri(tomorrow);

      // Если завтра начинаются белые дни, одного напоминания достаточно:
      // не шлём вдобавок «завтра день желательного поста» в тот же вечер.
      final whiteDays = prefs.events.contains(NotificationEvent.fastWhiteDays) && FastingCalendar.isWhiteDaysReminder(h);
      if (whiteDays) {
        addEvent(date, NotificationEvent.fastWhiteDays, asr?.add(whiteDaysAfterAsr));
      } else if (!FastingCalendar.isFastReminderBlocked(h)) {
        final weekly = switch (tomorrow.weekday) {
          DateTime.monday => NotificationEvent.fastMonday,
          DateTime.thursday => NotificationEvent.fastThursday,
          _ => null,
        };
        if (weekly != null) {
          addEvent(date, weekly, maghrib?.add(fastReminderAfterMaghrib));
        }
      }

      // Дни идут по порядку: если лимит уже набран, дальше смотреть незачем.
      if (items.length >= maxCount) break;
    }

    if (items.isEmpty) return items;

    items.sort((a, b) => a.at.compareTo(b.at));
    final result = items.length >= maxCount ? items.sublist(0, maxCount - 1) : items;

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
        title: NotificationTexts.openAppTitle,
        body: NotificationTexts.openAppBody,
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
