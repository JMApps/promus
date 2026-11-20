import '../services/models.dart';

/// Особые дни хиджры для постов и напоминаний.
///
/// Чистая логика без Flutter и плагинов: на вход — уже посчитанная дата
/// хиджры (с пользовательским смещением), на выход — ответ «да/нет».
/// Используется и экраном (TimeState), и планировщиком уведомлений,
/// поэтому правила живут в одном месте.
abstract final class FastingCalendar {
  static const int muharram = 1;
  static const int ramadan = 9;
  static const int shawwal = 10;
  static const int dhulHijjah = 12;

  // ---------------------------------------------------------------------------
  // Обязательный пост и праздники
  // ---------------------------------------------------------------------------

  /// Весь месяц Рамадан.
  static bool isRamadan(HijriDate h) => h.month == ramadan;

  /// Номер дня Рамадана (1–30) или null вне Рамадана.
  static int? ramadanDay(HijriDate h) => isRamadan(h) ? h.day : null;

  /// Последние десять ночей Рамадана (21-я и далее).
  static bool isLastTenNightsOfRamadan(HijriDate h) => isRamadan(h) && h.day >= 21;

  /// Ид аль-Фитр (Ураза-байрам) — 1 шавваля.
  static bool isEidAlFitr(HijriDate h) => h.month == shawwal && h.day == 1;

  /// Ид аль-Адха (Курбан-байрам) — 10 зуль-хиджи.
  static bool isEidAlAdha(HijriDate h) => h.month == dhulHijjah && h.day == 10;

  /// Дни ташрик — 11, 12, 13 зуль-хиджи.
  static bool isTashriq(HijriDate h) => h.month == dhulHijjah && h.day >= 11 && h.day <= 13;

  /// Дни, в которые поститься запрещено: оба Ида и дни ташрик.
  static bool isFastingForbidden(HijriDate h) => isEidAlFitr(h) || isEidAlAdha(h) || isTashriq(h);

  /// Напоминать о ДОБРОВОЛЬНОМ посте в этот день не нужно:
  /// в Рамадан пост и так обязательный, а в праздники и ташрик запрещён.
  static bool isVoluntaryFastReminderBlocked(HijriDate h) => isRamadan(h) || isFastingForbidden(h);

  /// Напоминание «завтра день желательного поста» накануне [tomorrow] не шлём:
  /// Рамадан, оба Ида, дни ташрик и 'Ашура.
  static bool isFastReminderBlocked(HijriDate tomorrow) => isVoluntaryFastReminderBlocked(tomorrow) || isAshura(tomorrow);

  /// Вечером 12-го: «завтра начинаются белые дни 13-14-15».
  /// В Рамадан и в зуль-хиджу (13-е — день ташрик) не напоминаем.
  static bool isWhiteDaysReminder(HijriDate tomorrow) => tomorrow.day == 13 && !isFastReminderBlocked(tomorrow);

  // ---------------------------------------------------------------------------
  // Желательные посты
  // ---------------------------------------------------------------------------

  /// Белые дни: 13, 14, 15 числа. В зуль-хиджу 13-е — день ташрик,
  /// поэтому остаются только 14 и 15. В Рамадан белых дней как
  /// добровольного поста нет.
  static bool isWhiteDay(HijriDate h) {
    if (isRamadan(h)) return false;
    if (h.month == dhulHijjah) return h.day == 14 || h.day == 15;
    return h.day >= 13 && h.day <= 15;
  }

  /// Первый день белых дней (с него начинается напоминание).
  static bool isWhiteDaysStart(HijriDate h) {
    if (isRamadan(h)) return false;
    return h.month == dhulHijjah ? h.day == 14 : h.day == 13;
  }

  /// День ʿАрафа — 9 зуль-хиджи.
  static bool isArafah(HijriDate h) => h.month == dhulHijjah && h.day == 9;

  /// Первые девять дней зуль-хиджи (желательный пост).
  static bool isFirstNineDaysOfDhulHijjah(HijriDate h) => h.month == dhulHijjah && h.day <= 9;

  /// Тасуʿа — 9 мухаррама.
  static bool isTasua(HijriDate h) => h.month == muharram && h.day == 9;

  /// ʿАшура — 10 мухаррама.
  static bool isAshura(HijriDate h) => h.month == muharram && h.day == 10;

  /// Шесть дней шавваля можно поститься со 2-го числа до конца месяца.
  static bool isShawwalSixDaysPeriod(HijriDate h) => h.month == shawwal && h.day >= 2;

  /// Понедельник или четверг, если в этот день добровольный пост уместен.
  static bool isMondayOrThursdayFast(DateTime date, HijriDate h) =>
      (date.weekday == DateTime.monday || date.weekday == DateTime.thursday) && !isVoluntaryFastReminderBlocked(h);
}
