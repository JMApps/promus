import 'package:adhan/adhan.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';

/// Готовые данные одного круга: имя, длительность и прогресс 0..1.
/// Виджеты получают только это и ничего не считают сами.
class SleekData {
  const SleekData({
    required this.name,
    required this.duration,
    required this.progress,
  });

  final String name;
  final Duration duration;
  final double progress;

  /// Длительность в формате HH:mm.
  String get timeText {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class PrayerState extends ChangeNotifier with WidgetsBindingObserver {
  // ---------------------------------------------------------------------------
  // ВАЖНО: работаем в часовом поясе устройства.
  //
  // Осознанное ограничение: расчёт корректен, пока пользователь физически
  // находится в выбранном городе. Пакет timezone убран — tz.local без явного
  // setLocalLocation() всё равно был UTC, и isFriday/weekday считались
  // по UTC-дню недели, что ломало пятничную логику на границах суток.
  // Обычный DateTime.now() честно даёт локальные настенные часы.
  // ---------------------------------------------------------------------------

  late final Box _settingsPrayerTimeBox;
  DateTime _dateTime = DateTime.now();
  final Cron _cron = Cron();
  static const Duration hourInterval = Duration(hours: 1);

  late PrayerTimes _prayerTimes;
  late CalculationParameters _prayerParams;
  late Coordinates _coordinates;
  late SunnahTimes _sunnahTimes;
  late Qibla _qibla;

  late int _fajrAdjustment;
  late int _sunriseAdjustment;
  late int _dhuhrAdjustment;
  late int _asrAdjustment;
  late int _maghribAdjustment;
  late int _ishaAdjustment;

  late String _country;
  late String _city;

  late double _latitude;
  late double _longitude;

  late int _calculationMethodIndex;
  late int _highLatitudeMethodIndex;
  late bool _dst;
  late int _madhabIndex;

  PrayerState(this._settingsPrayerTimeBox) {
    WidgetsBinding.instance.addObserver(this);

    _fajrAdjustment = _settingsPrayerTimeBox.get(AppConstants.keyFajrAdjustment, defaultValue: 0);
    _sunriseAdjustment = _settingsPrayerTimeBox.get(AppConstants.keySunriseAdjustment, defaultValue: 0);
    _dhuhrAdjustment = _settingsPrayerTimeBox.get(AppConstants.keyDhuhrAdjustment, defaultValue: 0);
    _asrAdjustment = _settingsPrayerTimeBox.get(AppConstants.keyAsrAdjustment, defaultValue: 0);
    _maghribAdjustment = _settingsPrayerTimeBox.get(AppConstants.keyMaghribAdjustment, defaultValue: 0);
    _ishaAdjustment = _settingsPrayerTimeBox.get(AppConstants.keyIshaAdjustment, defaultValue: 0);

    _country = _settingsPrayerTimeBox.get(AppConstants.keyCountry, defaultValue: 'Saudi Arabia');
    _city = _settingsPrayerTimeBox.get(AppConstants.keyCity, defaultValue: 'Mecca');
    _latitude = _settingsPrayerTimeBox.get(AppConstants.keyCurrentLatitude, defaultValue: 21.42580);
    _longitude = _settingsPrayerTimeBox.get(AppConstants.keyCurrentLongitude, defaultValue: 39.82410);
    _calculationMethodIndex = _settingsPrayerTimeBox.get(AppConstants.keyCalculationIndex, defaultValue: 10);
    _highLatitudeMethodIndex = _settingsPrayerTimeBox.get(AppConstants.keyHighLatitudeIndex, defaultValue: 0);
    _madhabIndex = _settingsPrayerTimeBox.get(AppConstants.keyMadhabIndex, defaultValue: 0);
    _dst = _settingsPrayerTimeBox.get(AppConstants.keyDST, defaultValue: false);

    _startCron();
    initPrayerTime();
  }

  // ---------------------------------------------------------------------------
  // Расчёт Adhan. Вызывается при старте, смене настроек и смене даты.
  // ---------------------------------------------------------------------------

  void initPrayerTime() {
    _coordinates = Coordinates(_latitude, _longitude);

    _prayerParams = AppConstants.prayerCalculationMethods[_calculationMethodIndex].getParameters()
      ..highLatitudeRule = AppConstants.highLatitude[_highLatitudeMethodIndex]
      ..madhab = AppConstants.calculationMadhab[_madhabIndex];

    // ИСПРАВЛЕНО: знак DST. Тумблер нужен, когда устройство живёт в поясе
    // без перевода часов, а официальные времена летом сдвинуты ВПЕРЁД,
    // поэтому при включённом DST минуты ПРИБАВЛЯЮТСЯ.
    final offset = _dst ? 60 : 0;

    _prayerParams.adjustments.fajr = _fajrAdjustment + offset;
    _prayerParams.adjustments.sunrise = _sunriseAdjustment + offset;
    _prayerParams.adjustments.dhuhr = _dhuhrAdjustment + offset;
    _prayerParams.adjustments.asr = _asrAdjustment + offset;
    _prayerParams.adjustments.maghrib = _maghribAdjustment + offset;
    _prayerParams.adjustments.isha = _ishaAdjustment + offset;

    _prayerTimes = PrayerTimes.today(_coordinates, _prayerParams);
    _sunnahTimes = SunnahTimes(_prayerTimes);
    _qibla = Qibla(_coordinates);
    notifyListeners();
  }

  /// Расчёт на произвольную дату (для расписания и точных недельных уведомлений).
  PrayerTimes prayerTimeSchedule({required DateTime time}) {
    return PrayerTimes(_coordinates, DateComponents.from(time), _prayerParams);
  }

  // ---------------------------------------------------------------------------
  // Тик раз в минуту: cron сам стреляет в начале каждой минуты.
  // ---------------------------------------------------------------------------

  void _startCron() {
    _cron.schedule(Schedule.parse('*/1 * * * *'), _updateDateTime);
  }

  void _updateDateTime() {
    final previous = _dateTime;
    _dateTime = DateTime.now();

    // ИСПРАВЛЕНО: пересчёт при смене календарной даты. Без этого приложение,
    // пережившее полночь, весь следующий день показывает вчерашние времена.
    // initPrayerTime() сам вызовет notifyListeners.
    if (previous.year != _dateTime.year ||
        previous.month != _dateTime.month ||
        previous.day != _dateTime.day) {
      initPrayerTime();
      return;
    }

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Три круга главного экрана. Упрощение, которое мы приняли: один расчёт
  // на день, ночные границы закрываются сдвигом ±24 часа (погрешность 1–2 мин).
  // ---------------------------------------------------------------------------

  static const Duration _day = Duration(hours: 24);

  /// Пять молитв сегодняшнего дня по порядку.
  List<({String name, DateTime time})> get _todayPrayers => [
    (name: AppStrings.prayerFajr, time: _prayerTimes.fajr),
    (name: AppStrings.prayerDhuhr, time: _prayerTimes.dhuhr),
    (name: AppStrings.prayerAsr, time: _prayerTimes.asr),
    (name: AppStrings.prayerMaghrib, time: _prayerTimes.maghrib),
    (name: AppStrings.prayerIsha, time: _prayerTimes.isha),
  ];

  /// Последняя наступившая молитва. До фаджра — вчерашняя 'иша (сдвиг −24ч).
  ({String name, DateTime time}) get _lastPrayer {
    final passed = _todayPrayers.where((p) => !p.time.isAfter(_dateTime));
    if (passed.isEmpty) {
      return (name: AppStrings.prayerIsha, time: _prayerTimes.isha.subtract(_day));
    }
    return passed.last;
  }

  /// Ближайшая будущая молитва. После 'иши — завтрашний фаджр (сдвиг +24ч).
  ({String name, DateTime time}) get _nextPrayerEntry {
    final upcoming = _todayPrayers.where((p) => p.time.isAfter(_dateTime));
    if (upcoming.isEmpty) {
      return (name: AppStrings.prayerFajr, time: _prayerTimes.fajr.add(_day));
    }
    return upcoming.first;
  }

  /// Ближайшее будущее событие третьего круга. Якорь — начало интервала,
  /// от которого считается прогресс приближения к событию.
  ({String name, DateTime time, DateTime anchor}) get _nextEvent {
    final candidates = <({String name, DateTime time, DateTime anchor})>[
      (
      name: AppStrings.sunrise,
      time: _prayerTimes.sunrise,
      anchor: _prayerTimes.fajr,
      ),
      (
      name: AppStrings.midnight,
      time: _sunnahTimes.middleOfTheNight,
      anchor: _prayerTimes.maghrib,
      ),
      (
      name: AppStrings.lastThirdNight,
      time: _sunnahTimes.lastThirdOfTheNight,
      anchor: _sunnahTimes.middleOfTheNight,
      ),
      // Запас на глубокую ночь после последней трети: завтрашний восход.
      (
      name: AppStrings.sunrise,
      time: _prayerTimes.sunrise.add(_day),
      anchor: _prayerTimes.fajr.add(_day),
      ),
    ];

    final upcoming = candidates.where((e) => e.time.isAfter(_dateTime)).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    return upcoming.first;
  }

  /// Доля пройденного интервала [from; to] на текущий момент, 0..1.
  double _fraction({required DateTime from, required DateTime to}) {
    final total = to.difference(from).inSeconds;
    if (total <= 0) return 0;
    return (_dateTime.difference(from).inSeconds / total).clamp(0.0, 1.0);
  }

  /// Круг 1: последняя молитва и прошедшее с неё время. Прогресс растёт 0→1.
  SleekData get elapsed {
    final last = _lastPrayer;
    return SleekData(
      name: last.name,
      duration: _dateTime.difference(last.time),
      progress: _fraction(from: last.time, to: _nextPrayerEntry.time),
    );
  }

  /// Круг 2: следующая молитва и остаток до неё. Прогресс убывает 1→0.
  SleekData get remaining {
    final next = _nextPrayerEntry;
    return SleekData(
      name: next.name,
      duration: next.time.difference(_dateTime),
      progress: 1 - _fraction(from: _lastPrayer.time, to: next.time),
    );
  }

  /// Круг 3: ближайшее событие (восход / полночь / треть) и остаток до него.
  SleekData get event {
    final e = _nextEvent;
    return SleekData(
      name: e.name,
      duration: e.time.difference(_dateTime),
      progress: 1 - _fraction(from: e.anchor, to: e.time),
    );
  }

  // ---------------------------------------------------------------------------
  // Основные геттеры
  // ---------------------------------------------------------------------------

  PrayerTimes get prayerTimes => _prayerTimes;

  SunnahTimes get sunnahTimes => _sunnahTimes;

  Qibla get qiblahDirection => _qibla;

  String get country => _country;

  String get city => _city;

  double get latitude => _latitude;

  double get longitude => _longitude;

  String get gregorianDateText => '${_dateTime.day} ${AppConstants.gregorianMonths[_dateTime.month - 1]}, ${_dateTime.year}';
  String get hijriDateText {
    final h = HijriCalendar.fromDate(_dateTime);
    return '${h.hDay} ${AppConstants.hijriMonths[h.hMonth - 1]}, ${h.hYear}';
  }

  // ---------------------------------------------------------------------------
  // Смена локации.
  //
  // ИСПРАВЛЕНО: раньше сеттеры lat/lng писали в Hive, но не пересчитывали
  // времена — вызывающий код был обязан помнить про initPrayerTime().
  // Теперь локация меняется одним атомарным методом.
  // ---------------------------------------------------------------------------

  void setLocation({
    required String country,
    required String city,
    required double latitude,
    required double longitude,
  }) {
    _country = country;
    _city = city;
    _latitude = latitude;
    _longitude = longitude;

    _settingsPrayerTimeBox.put(AppConstants.keyCountry, country);
    _settingsPrayerTimeBox.put(AppConstants.keyCity, city);
    _settingsPrayerTimeBox.put(AppConstants.keyCurrentLatitude, latitude);
    _settingsPrayerTimeBox.put(AppConstants.keyCurrentLongitude, longitude);

    initPrayerTime();
  }

  // ---------------------------------------------------------------------------
  // Настройки расчёта
  // ---------------------------------------------------------------------------

  int get calculationMethodIndex => _calculationMethodIndex;

  set setCalculationIndex(int index) {
    _calculationMethodIndex = index;
    _settingsPrayerTimeBox.put(AppConstants.keyCalculationIndex, index);
    initPrayerTime();
  }

  int get highLatitudeMethodIndex => _highLatitudeMethodIndex;

  set setHighLatitudeIndex(int index) {
    _highLatitudeMethodIndex = index;
    _settingsPrayerTimeBox.put(AppConstants.keyHighLatitudeIndex, index);
    initPrayerTime();
  }

  int get madhabIndex => _madhabIndex;

  set setMadhabIndex(int index) {
    _madhabIndex = index;
    _settingsPrayerTimeBox.put(AppConstants.keyMadhabIndex, index);
    initPrayerTime();
  }

  bool get dst => _dst;

  set setDst(bool dstState) {
    _dst = dstState;
    _settingsPrayerTimeBox.put(AppConstants.keyDST, dstState);
    initPrayerTime();
  }

  // ---------------------------------------------------------------------------
  // Ручные поправки по минутам
  // ---------------------------------------------------------------------------

  int get fajrAdjustment => _fajrAdjustment;

  int get sunriseAdjustment => _sunriseAdjustment;

  int get dhuhrAdjustment => _dhuhrAdjustment;

  int get asrAdjustment => _asrAdjustment;

  int get maghribAdjustment => _maghribAdjustment;

  int get ishaAdjustment => _ishaAdjustment;

  set fajrAdjustment(int value) {
    if (_fajrAdjustment != value) {
      _fajrAdjustment = value;
      _settingsPrayerTimeBox.put(AppConstants.keyFajrAdjustment, value);
      initPrayerTime();
    }
  }

  set sunriseAdjustment(int value) {
    if (_sunriseAdjustment != value) {
      _sunriseAdjustment = value;
      _settingsPrayerTimeBox.put(AppConstants.keySunriseAdjustment, value);
      initPrayerTime();
    }
  }

  set dhuhrAdjustment(int value) {
    if (_dhuhrAdjustment != value) {
      _dhuhrAdjustment = value;
      _settingsPrayerTimeBox.put(AppConstants.keyDhuhrAdjustment, value);
      initPrayerTime();
    }
  }

  set asrAdjustment(int value) {
    if (_asrAdjustment != value) {
      _asrAdjustment = value;
      _settingsPrayerTimeBox.put(AppConstants.keyAsrAdjustment, value);
      initPrayerTime();
    }
  }

  set maghribAdjustment(int value) {
    if (_maghribAdjustment != value) {
      _maghribAdjustment = value;
      _settingsPrayerTimeBox.put(AppConstants.keyMaghribAdjustment, value);
      initPrayerTime();
    }
  }

  set ishaAdjustment(int value) {
    if (_ishaAdjustment != value) {
      _ishaAdjustment = value;
      _settingsPrayerTimeBox.put(AppConstants.keyIshaAdjustment, value);
      initPrayerTime();
    }
  }

  /// ИСПРАВЛЕНО: был `void get defaultAdjustments` — геттер с побочными
  /// эффектами читается как опечатка. По смыслу это команда — значит метод.
  void resetAdjustments() {
    _fajrAdjustment = 0;
    _sunriseAdjustment = 0;
    _dhuhrAdjustment = 0;
    _asrAdjustment = 0;
    _maghribAdjustment = 0;
    _ishaAdjustment = 0;

    _settingsPrayerTimeBox.put(AppConstants.keyFajrAdjustment, 0);
    _settingsPrayerTimeBox.put(AppConstants.keySunriseAdjustment, 0);
    _settingsPrayerTimeBox.put(AppConstants.keyDhuhrAdjustment, 0);
    _settingsPrayerTimeBox.put(AppConstants.keyAsrAdjustment, 0);
    _settingsPrayerTimeBox.put(AppConstants.keyMaghribAdjustment, 0);
    _settingsPrayerTimeBox.put(AppConstants.keyIshaAdjustment, 0);

    initPrayerTime();
  }

  // ---------------------------------------------------------------------------
  // Вспомогательная логика (окна, периоды суток, пятница)
  // ---------------------------------------------------------------------------

  bool isPrayerInHourRange({required bool before, required DateTime prayerTime}) {
    final DateTime rangeStart = before ? prayerTime.subtract(hourInterval) : prayerTime;
    final DateTime rangeEnd = before ? prayerTime : prayerTime.add(hourInterval);
    return _dateTime.isAfter(rangeStart) && _dateTime.isBefore(rangeEnd);
  }

  /// ИСПРАВЛЕНО: убран .abs(). Он маскировал ошибки — при неверном выборе
  /// молитвы отрицательная разность молча превращалась в правдоподобную чушь.
  /// Теперь неверное состояние сразу видно на экране в дебаге.
  String restPrayerTime({required bool isBefore, required DateTime time}) {
    late final Duration remainingDuration;
    if (isBefore) {
      if (!_dateTime.isBefore(time)) {
        time = time.add(const Duration(days: 1));
      }
      remainingDuration = time.difference(_dateTime);
    } else {
      remainingDuration = _dateTime.difference(time);
    }
    final hours = remainingDuration.inHours.remainder(24);
    final minutes = remainingDuration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String fromFajrToMaghribFormatted({required List<String> timeVariations}) {
    final duration = _prayerTimes.maghrib.difference(_prayerTimes.fajr);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final hoursText = _pluralize(hours, timeVariations[0], timeVariations[1], timeVariations[2]);
    final String minutesText = _pluralize(minutes, timeVariations[3], timeVariations[4], timeVariations[5]);
    return '$hoursText $minutesText';
  }

  bool isNextPrayer({required Prayer prayer}) => _prayerTimes.nextPrayer() == prayer;

  bool isAdhan({required Prayer prayer}) {
    return _dateTime.isAfter(_timeAdhanAdhkar(prayer).subtract(const Duration(minutes: 2))) &&
        _dateTime.isBefore(_timeAdhanAdhkar(prayer).add(const Duration(minutes: 3)));
  }

  bool isDhikr({required Prayer prayer}) {
    return _dateTime.isAfter(_timeAdhanAdhkar(prayer).add(const Duration(minutes: 3))) &&
        _dateTime.isBefore(_timeAdhanAdhkar(prayer).add(const Duration(minutes: 30)));
  }

  DateTime _timeAdhanAdhkar(Prayer prayer) {
    final DateTime currentPrayerTime;
    if (prayer == Prayer.none) {
      currentPrayerTime = _prayerTimes.timeForPrayer(Prayer.fajr)!;
    } else if (prayer == Prayer.sunrise) {
      currentPrayerTime = _prayerTimes.timeForPrayer(Prayer.dhuhr)!;
    } else {
      currentPrayerTime = _prayerTimes.timeForPrayer(prayer)!;
    }
    return currentPrayerTime;
  }

  bool get isMorning => _isWithinRange(_prayerTimes.fajr.add(const Duration(minutes: 30)), _prayerTimes.sunrise);

  bool get isSunrise => _isWithinRange(_prayerTimes.sunrise, _prayerTimes.dhuhr);

  bool get isDuha => _isWithinRange(
      _prayerTimes.sunrise.add(const Duration(minutes: 45)), _prayerTimes.dhuhr.subtract(const Duration(minutes: 15)));

  bool get isEvening => _isWithinRange(_prayerTimes.asr.add(const Duration(minutes: 30)), _prayerTimes.maghrib);

  bool get isNight => _isWithinRange(_prayerTimes.isha.add(const Duration(minutes: 30)), _sunnahTimes.middleOfTheNight);

  bool get isMidnight => _isWithinRange(_sunnahTimes.middleOfTheNight, _sunnahTimes.lastThirdOfTheNight);

  bool get isLastThird => _isWithinRange(_sunnahTimes.lastThirdOfTheNight, _prayerTimes.fajr.add(_day));

  bool get isNightTime => _isWithinRange(_prayerTimes.maghrib, _prayerTimes.fajr.add(const Duration(days: 1)));

  // Пятничная логика: weekday теперь честно локальный, потому что _dateTime —
  // обычный DateTime.now(), а не TZDateTime в невыставленном tz.local (UTC).
  bool get isLastFridayHour =>
      _dateTime.weekday == DateTime.friday &&
          _isWithinRange(_prayerTimes.maghrib.subtract(const Duration(hours: 1)), _prayerTimes.maghrib);

  bool get isFriday {
    final bool firstCheck = _dateTime.weekday == DateTime.thursday && _dateTime.isAfter(_prayerTimes.maghrib);
    final bool secondCheck = _dateTime.weekday == DateTime.friday && _dateTime.isBefore(_prayerTimes.maghrib);
    return firstCheck || secondCheck;
  }

  // ---------------------------------------------------------------------------
  // Недельные точки для уведомлений
  // ---------------------------------------------------------------------------

  DateTime get lastFridayHour => _getWeeklyNotificationTime(DateTime.friday, const Duration(hours: -1));

  DateTime get weeklyThursday => _getWeeklyNotificationTime(DateTime.thursday, const Duration(hours: 1));

  DateTime get weeklyWednesday => _getWeeklyNotificationTime(DateTime.wednesday, const Duration(hours: 1));

  DateTime get weeklySunday => _getWeeklyNotificationTime(DateTime.sunday, const Duration(hours: 1));

  /// ИСПРАВЛЕНО: магриб берётся расчётом на целевой день, а не сегодняшний —
  /// через неделю магриб уезжает на 5–10 минут, для уведомлений это заметно.
  DateTime _getWeeklyNotificationTime(int targetWeekday, Duration timeOffset) {
    final DateTime nextTargetDay = _dateTime.add(Duration(days: (targetWeekday - _dateTime.weekday + 7) % 7));
    final DateTime targetMaghrib = prayerTimeSchedule(time: nextTargetDay).maghrib;
    return targetMaghrib.add(timeOffset);
  }

  bool _isWithinRange(DateTime start, DateTime end) {
    return _dateTime.isAfter(start) && _dateTime.isBefore(end);
  }

  String _pluralize(int number, String one, String few, String many) {
    final int n = number % 100;
    if (n >= 11 && n <= 14) return '$number $many';
    switch (n % 10) {
      case 1:
        return '$number $one';
      case 2:
      case 3:
      case 4:
        return '$number $few';
      default:
        return '$number $many';
    }
  }

  // ---------------------------------------------------------------------------
  // Жизненный цикл
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // ИСПРАВЛЕНО: убран дублирующий notifyListeners — _updateDateTime сам
      // нотифицирует (или пересчитывает через initPrayerTime при смене даты,
      // что закрывает случай «приложение провело ночь в фоне»).
      _updateDateTime();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cron.close();
    super.dispose();
  }
}