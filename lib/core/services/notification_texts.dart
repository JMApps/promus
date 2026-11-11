import 'package:timezone/timezone.dart' as tz;

import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

/// Тексты уведомлений. Вшиваются в момент планирования, поэтому смена языка
/// должна вызывать синхронизацию (если появится локализация).
class NotificationTexts {
  const NotificationTexts();

  String prayerTitle(PrayerLabels p, String time) => '${p.label} — $time';

  String prayerBody(PrayerLabels p) => p == PrayerLabels.sunrise
      ? 'Восход солнца: время утреннего намаза закончилось'
      : 'Наступило время намаза «${p.label}»';

  String iqamahTitle(PrayerLabels p, String time) => 'Икама: ${p.label} — $time';

  String iqamahBody(PrayerLabels p) => 'Время икамы намаза «${p.label}»';

  String eventTitle(NotificationEvent e) => e.label;

  /// [hijriMonth] — месяц дня, к которому относится напоминание (для белых дней).
  String eventBody(NotificationEvent e, {int? hijriMonth}) => switch (e) {
    NotificationEvent.friday =>
    'Сегодня джума: прочитайте суру «аль-Кахф» и чаще призывайте благословение на Пророка ﷺ',
    NotificationEvent.fridayLastHour =>
    'Начался последний час пятницы — время, когда мольба принимается',
    NotificationEvent.fastMonday =>
    'Завтра понедельник — желательный пост. Не забудьте сухур и намерение',
    NotificationEvent.fastThursday =>
    'Завтра четверг — желательный пост. Не забудьте сухур и намерение',
    NotificationEvent.fastWhiteDays => hijriMonth == 12
        ? 'Завтра начинаются белые дни: желательно поститься 14 и 15 зу-ль-хиджа'
        : 'Завтра начинаются белые дни: желательно поститься 13, 14 и 15 числа',
  };

  String get openAppTitle => 'Уведомления скоро закончатся';

  String get openAppBody => 'Откройте приложение, чтобы получать время намазов на следующие дни';

  /// Время в часовом поясе устройства, формат ЧЧ:ММ.
  String formatTime(DateTime at) {
    final local = tz.TZDateTime.from(at, tz.local);
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}