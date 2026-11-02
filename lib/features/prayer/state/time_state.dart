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

  /// Сколько дней до ближайшей хиджрийской даты [hijriMonth]/[hijriDay].
  /// Если дата сегодня, количество дней будет 0.
  Map<String, dynamic> getDaysToHijriDate({required int hijriMonth, required int hijriDay, required String daysKey, required String dateKey}) {
    final h = _hijriCalendar;
    final passed = h.hMonth > hijriMonth || (h.hMonth == hijriMonth && h.hDay > hijriDay);

    final targetDate = h.hijriToGregorian(
      passed ? h.hYear + 1 : h.hYear,
      hijriMonth,
      hijriDay,
    );

    // Сравниваем только даты, без часов и минут.
    final today = DateTime.utc(_dateTime.year, _dateTime.month, _dateTime.day);
    final target = DateTime.utc(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    return {
      daysKey: target.difference(today).inDays,
      dateKey: targetDate,
    };
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