import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

/// Хранит текущую григорианскую и хиджрийскую дату и правила постов.
///
/// Слушатели уведомляются только при смене календарного дня.
/// Если в UI нужны живые часы или минуты, используйте для них
/// отдельный источник (например, StreamBuilder с Stream.periodic).
class TimeState extends ChangeNotifier with WidgetsBindingObserver {
  /// [now] можно подменить в тестах, чтобы проверять граничные даты.
  TimeState({DateTime Function()? now}) : _now = now ?? DateTime.now {
    final current = _now();
    _dateTime = current;
    _hijriCalendar = HijriCalendar.fromDate(current);

    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _refresh());
  }

  final DateTime Function() _now;
  late DateTime _dateTime;
  late HijriCalendar _hijriCalendar;
  Timer? _timer;

  DateTime get getDateTime => _dateTime;

  HijriCalendar get getHijriDateTime => _hijriCalendar;

  // ---------------------------------------------------------------------------
  // Особые периоды
  // ---------------------------------------------------------------------------

  bool isRamadan() => _hijriCalendar.hMonth == 9;

  /// Первые 9 дней Зуль-хиджа.
  bool isDhulhijjah() => _hijriCalendar.hMonth == 12 && _hijriCalendar.hDay <= 9;

  /// Ид аль-Фитр (1 шавваля).
  bool isRamadanHoliday() => _hijriCalendar.hMonth == 10 && _hijriCalendar.hDay == 1;

  /// Ид аль-Адха и дни ташрика (10–13 Зуль-хиджа): пост запрещён.
  bool isDhulhijjahHoliday() => _hijriCalendar.hMonth == 12 && _hijriCalendar.hDay >= 10 && _hijriCalendar.hDay <= 13;

  // ---------------------------------------------------------------------------
  // Добровольные посты
  // ---------------------------------------------------------------------------

  /// Можно ли сегодня держать добровольный пост
  /// (не Рамадан, не первые дни Зуль-хиджа и не праздники).
  bool isFasting() => !isRamadan() && !isDhulhijjah() && !isRamadanHoliday() && !isDhulhijjahHoliday();

  /// Канун «белых дней» (12-е число).
  bool isNearWhiteDays() => isFasting() && _hijriCalendar.hDay == 12;

  /// «Белые дни» (13–15 числа).
  bool isWhiteDays() => isFasting() && _hijriCalendar.hDay >= 13 && _hijriCalendar.hDay <= 15;

  /// Среда и воскресенье: канун понедельника и четверга.
  bool isNearThirdSixth() => isFasting() && (_dateTime.weekday == DateTime.wednesday || _dateTime.weekday == DateTime.sunday);

  /// Понедельник и четверг.
  bool isFirstFourth() => isFasting() && (_dateTime.weekday == DateTime.monday || _dateTime.weekday == DateTime.thursday);

  // ---------------------------------------------------------------------------
  // Вычисления дат
  // ---------------------------------------------------------------------------

  /// Ближайшее 12-е число хиджрийского месяца (сегодня, если сегодня 12-е).
  DateTime get twelfthDay {
    final h = _hijriCalendar;
    var year = h.hYear;
    var month = h.hMonth;
    if (h.hDay > 12) {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }
    return h.hijriToGregorian(year, month, 12);
  }

  /// Ближайшая григорианская дата для хиджрийской даты [month]/[day].
  /// Если дата сегодня, вернёт сегодняшний день.
  DateTime nextHijriDate(int month, int day) {
    final h = _hijriCalendar;
    final passed = h.hMonth > month || (h.hMonth == month && h.hDay > day);
    final year = passed ? h.hYear + 1 : h.hYear;

    // В хиджрийском месяце 29 или 30 дней: не выходим за его границы.
    final lastDay = h.getDaysInMonth(year, month);
    return h.hijriToGregorian(year, month, day > lastDay ? lastDay : day);
  }

  /// Сколько дней осталось до ближайшей хиджрийской даты [month]/[day].
  /// Если дата сегодня, вернёт 0.
  int daysUntilHijri(int month, int day) {
    final target = nextHijriDate(month, day);

    // Сравниваем только даты, без часов и минут.
    final today = DateTime.utc(_dateTime.year, _dateTime.month, _dateTime.day);
    final targetDay = DateTime.utc(target.year, target.month, target.day);

    return targetDay.difference(today).inDays;
  }

  // ---------------------------------------------------------------------------
  // Обновление
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  void _refresh() {
    final now = _now();
    final dayChanged = now.year != _dateTime.year || now.month != _dateTime.month || now.day != _dateTime.day;

    _dateTime = now;

    if (dayChanged) {
      // Хиджру считаем от того же момента, чтобы даты не разошлись.
      _hijriCalendar = HijriCalendar.fromDate(now);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}