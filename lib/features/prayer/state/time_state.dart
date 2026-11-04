import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class TimeState extends ChangeNotifier with WidgetsBindingObserver {
  TimeState({DateTime Function()? now}) : _now = now ?? DateTime.now {
    final current = _now();
    _dateTime = current;
    _hijriCalendar = HijriCalendar.fromDate(current);

    WidgetsBinding.instance.addObserver(this);
    _scheduleNextMidnight();
  }

  void _scheduleNextMidnight() {
    _timer?.cancel();
    final now = _now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _timer = Timer(nextMidnight.difference(now), () {
      _refresh();
      _scheduleNextMidnight();
    });
  }

  final DateTime Function() _now;
  late DateTime _dateTime;
  late HijriCalendar _hijriCalendar;
  Timer? _timer;

  DateTime get getDateTime => _dateTime;

  HijriCalendar get getHijriDateTime => _hijriCalendar;

  bool isRamadan() => _hijriCalendar.hMonth == 9;

  bool isDhulhijjah() => _hijriCalendar.hMonth == 12 && _hijriCalendar.hDay <= 9;

  bool isRamadanHoliday() => _hijriCalendar.hMonth == 10 && _hijriCalendar.hDay == 1;

  bool isDhulhijjahHoliday() => _hijriCalendar.hMonth == 12 && _hijriCalendar.hDay >= 10 && _hijriCalendar.hDay <= 13;

  bool isFasting() => !isRamadan() && !isDhulhijjah() && !isRamadanHoliday() && !isDhulhijjahHoliday();

  bool isNearWhiteDays() => isFasting() && _hijriCalendar.hDay == 12;

  bool isWhiteDays() => isFasting() && _hijriCalendar.hDay >= 13 && _hijriCalendar.hDay <= 15;

  bool isNearThirdSixth() => isFasting() && (_dateTime.weekday == DateTime.wednesday || _dateTime.weekday == DateTime.sunday);

  bool isFirstFourth() => isFasting() && (_dateTime.weekday == DateTime.monday || _dateTime.weekday == DateTime.thursday);

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

  DateTime nextHijriDate(int month, int day) {
    final h = _hijriCalendar;
    final passed = h.hMonth > month || (h.hMonth == month && h.hDay > day);
    final year = passed ? h.hYear + 1 : h.hYear;

    final lastDay = h.getDaysInMonth(year, month);
    return h.hijriToGregorian(year, month, day > lastDay ? lastDay : day);
  }

  int daysUntilHijri(int month, int day) {
    final target = nextHijriDate(month, day);

    final today = DateTime.utc(_dateTime.year, _dateTime.month, _dateTime.day);
    final targetDay = DateTime.utc(target.year, target.month, target.day);

    return targetDay.difference(today).inDays;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  void _refresh() {
    final now = _now();
    final dayChanged = now.year != _dateTime.year || now.month != _dateTime.month || now.day != _dateTime.day;

    if (dayChanged) {
      _dateTime = now;
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