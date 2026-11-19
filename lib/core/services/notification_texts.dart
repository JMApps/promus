import 'package:timezone/timezone.dart' as tz;

import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

/// Тексты уведомлений. Вшиваются в момент планирования, поэтому смена языка
/// должна вызывать синхронизацию (если появится локализация).
class NotificationTexts {
  const NotificationTexts();

  String prayerTitle(PrayerLabels p, String time) => '${p.label} — $time';

  String prayerBody(PrayerLabels p) => p == PrayerLabels.sunrise ? 'Восход солнца' : 'Наступило время молитвы «${p.label}»';

  String iqamahTitle(PrayerLabels p, String time) => 'Икама: ${p.label} — $time';

  String iqamahBody(PrayerLabels p) => 'Время икамы молитвы «${p.label}»';

  String eventTitle(NotificationEvent e) => e.label;

  /// [hijriMonth] — месяц дня, к которому относится напоминание (для белых дней).
  String eventBody(NotificationEvent e, {int? hijriMonth}) => switch (e) {
    NotificationEvent.friday => 'Сегодня пятница: прочитайте суру «аль-Кахф» и чаще призывайте благословение на Пророка ﷺ',
    NotificationEvent.fridayLastHour => 'Последний час пятницы 🤲🤲🤲',
    NotificationEvent.fastMonday => 'Завтра понедельник — желательный пост.',
    NotificationEvent.fastThursday => 'Завтра четверг — желательный пост.',
    NotificationEvent.fastWhiteDays => hijriMonth == 12 ? 'Завтра начинаются белые дни: желательно поститься 14 и 15 зу-ль-хиджа' : 'Завтра начинаются белые дни: желательно поститься 13, 14 и 15 числа',
  };

  String get openAppTitle => 'Уведомления скоро закончатся';

  String get openAppBody => 'Откройте приложение, чтобы перепланировались уведомления для молитв.';

  /// Время в часовом поясе устройства, формат ЧЧ:ММ.
  String formatTime(DateTime at) {
    final local = tz.TZDateTime.from(at, tz.local);
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}