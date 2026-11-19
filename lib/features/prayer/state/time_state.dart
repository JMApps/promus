import 'dart:async';

import 'package:hijri/hijri_calendar.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_prayer_keys.dart';
import '../../../core/services/models.dart';
import '../../../core/utils/fasting_calendar.dart';

/// Календарный «сегодня» (григорианский и хиджры) с переходом в полночь.
///
/// Дата хиджры всегда считается с пользовательским смещением из
/// настроек ([AppPrayerKeys.keyHijriOffset]) — так же, как в PrayerState,
/// поэтому карточка даты, «дни до Рамадана», праздники и уведомления
/// о постах никогда не расходятся между собой.
class TimeState extends ChangeNotifier with WidgetsBindingObserver {
  TimeState({
    required Box settingsPrayerTimeBox,
    DateTime Function()? now,
  }) : _box = settingsPrayerTimeBox,
       _now = now ?? DateTime.now {
    _hijriOffset = _readOffset();
    _dateTime = _dateOnly(_now());
    _hijriCalendar = hijriFor(_dateTime);

    _offsetSubscription = _box.watch(key: AppPrayerKeys.keyHijriOffset).listen((_) => _onOffsetChanged());

    WidgetsBinding.instance.addObserver(this);
    _scheduleNextMidnight();
  }

  final Box _box;
  final DateTime Function() _now;

  late DateTime _dateTime;
  late HijriCalendar _hijriCalendar;
  late int _hijriOffset;

  Timer? _timer;
  StreamSubscription<BoxEvent>? _offsetSubscription;

  // ---------------------------------------------------------------------------
  // Сегодня
  // ---------------------------------------------------------------------------

  /// Сегодняшняя дата (без времени).
  DateTime get getDateTime => _dateTime;

  /// Сегодняшняя дата хиджры с учётом смещения.
  HijriCalendar get getHijriDateTime => _hijriCalendar;

  int get hijriOffset => _hijriOffset;

  HijriDate get _todayHijri => _toHijriDate(_hijriCalendar);

  bool isRamadan() => FastingCalendar.isRamadan(_todayHijri);

  /// День Рамадана (1–30) или null.
  int? get ramadanDay => FastingCalendar.ramadanDay(_todayHijri);

  bool isEidAlFitr() => FastingCalendar.isEidAlFitr(_todayHijri);

  bool isEidAlAdha() => FastingCalendar.isEidAlAdha(_todayHijri);

  bool isTashriq() => FastingCalendar.isTashriq(_todayHijri);

  bool isArafah() => FastingCalendar.isArafah(_todayHijri);

  bool isAshura() => FastingCalendar.isAshura(_todayHijri);

  bool isFirstNineDaysOfDhulHijjah() => FastingCalendar.isFirstNineDaysOfDhulHijjah(_todayHijri);

  /// Сегодня поститься запрещено (Иды, ташрик).
  bool isFastingForbidden() => FastingCalendar.isFastingForbidden(_todayHijri);

  /// Сегодня белый день (13–15; в зуль-хиджу только 14–15; не в Рамадан).
  bool isWhiteDays() => FastingCalendar.isWhiteDay(_todayHijri);

  /// Завтра начинаются белые дни.
  bool isNearWhiteDays() => FastingCalendar.isWhiteDaysStart(hijriDateFor(_tomorrow));

  /// Сегодня понедельник/четверг и добровольный пост уместен.
  bool isMondayOrThursdayFast() => FastingCalendar.isMondayOrThursdayFast(_dateTime, _todayHijri);

  // ---------------------------------------------------------------------------
  // Произвольная дата
  // ---------------------------------------------------------------------------

  /// Дата хиджры для григорианского дня с учётом смещения.
  HijriCalendar hijriFor(DateTime date) =>
      HijriCalendar.fromDate(DateTime(date.year, date.month, date.day + _hijriOffset));

  /// То же, в виде [HijriDate] — для планировщика уведомлений.
  HijriDate hijriDateFor(DateTime date) => _toHijriDate(hijriFor(date));

  /// Не напоминать о добровольном посте в этот день:
  /// Рамадан, Ид аль-Фитр, Ид аль-Адха, дни ташрик.
  bool isVoluntaryFastReminderBlockedOn(DateTime date) =>
      FastingCalendar.isVoluntaryFastReminderBlocked(hijriDateFor(date));

  bool isRamadanOn(DateTime date) => FastingCalendar.isRamadan(hijriDateFor(date));

  /// Григорианский день, которому соответствует дата хиджры
  /// (обратное преобразование с учётом смещения).
  DateTime gregorianFor(int hYear, int hMonth, int hDay) {
    final lastDay = _hijriCalendar.getDaysInMonth(hYear, hMonth);
    final g = _hijriCalendar.hijriToGregorian(hYear, hMonth, hDay > lastDay ? lastDay : hDay);
    return DateTime(g.year, g.month, g.day - _hijriOffset);
  }

  /// Все дни текущего Рамадана, а если он уже прошёл в этом году хиджры
  /// (или ещё не начался) — ближайшего.
  List<DateTime> ramadanDays() {
    final h = _hijriCalendar;
    final year = h.hMonth > FastingCalendar.ramadan ? h.hYear + 1 : h.hYear;
    final length = h.getDaysInMonth(year, FastingCalendar.ramadan);
    final first = gregorianFor(year, FastingCalendar.ramadan, 1);
    return List.generate(
      length,
      (i) => DateTime(first.year, first.month, first.day + i),
      growable: false,
    );
  }

  /// Ближайшая (сегодня или позже) григорианская дата для дня хиджры.
  DateTime nextHijriDate(int month, int day) {
    final h = _hijriCalendar;
    final passed = h.hMonth > month || (h.hMonth == month && h.hDay > day);
    return gregorianFor(passed ? h.hYear + 1 : h.hYear, month, day);
  }

  /// Сколько дней осталось до дня хиджры (0 — сегодня).
  int daysUntilHijri(int month, int day) {
    final target = nextHijriDate(month, day);
    final today = DateTime.utc(_dateTime.year, _dateTime.month, _dateTime.day);
    return DateTime.utc(target.year, target.month, target.day).difference(today).inDays;
  }

  // ---------------------------------------------------------------------------
  // Служебное
  // ---------------------------------------------------------------------------

  DateTime get _tomorrow => DateTime(_dateTime.year, _dateTime.month, _dateTime.day + 1);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static HijriDate _toHijriDate(HijriCalendar h) => HijriDate(year: h.hYear, month: h.hMonth, day: h.hDay);

  int _readOffset() {
    final value = _box.get(AppPrayerKeys.keyHijriOffset);
    final offset = value is int ? value : 0;
    return offset.clamp(AppPrayerKeys.minHijriOffset, AppPrayerKeys.maxHijriOffset);
  }

  void _onOffsetChanged() {
    final offset = _readOffset();
    if (offset == _hijriOffset) return;
    _hijriOffset = offset;
    _hijriCalendar = hijriFor(_dateTime);
    notifyListeners();
  }

  void _scheduleNextMidnight() {
    _timer?.cancel();
    final now = _now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    // Небольшой запас, чтобы проснуться уже в новых сутках.
    _timer = Timer(nextMidnight.difference(now) + const Duration(seconds: 1), () {
      _refresh();
      _scheduleNextMidnight();
    });
  }

  void _refresh() {
    final today = _dateOnly(_now());
    if (today == _dateTime) return;
    _dateTime = today;
    _hijriCalendar = hijriFor(today);
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _refresh();
        _scheduleNextMidnight();
      case AppLifecycleState.paused:
        _timer?.cancel();
        _timer = null;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    unawaited(_offsetSubscription?.cancel());
    super.dispose();
  }
}
