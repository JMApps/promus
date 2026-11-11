import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/adhkar_reminders.dart';
import '../../../core/constants/app_constant_keys.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/entities/sleek_entity.dart';

/// Расчёт одних календарных суток.
typedef _Day = ({PrayerTimes times, SunnahTimes sunnah});

/// Момент молитвы в общем ряду «вчера → сегодня → завтра».
typedef _Moment = ({Prayer prayer, DateTime time});

/// Событие третьего круга. [anchor] — откуда считается прогресс.
typedef _Event = ({String name, DateTime time, DateTime anchor});

class PrayerState extends ChangeNotifier with WidgetsBindingObserver {
  PrayerState({required this._settingsPrayerTimeBox}) {
    _adjustments = {
      for (final e in _adjustmentKeys.entries) e.key: _read<int>(e.value, 0),
    };
    _country = _read(AppConstantKeys.keyCountry, AppStrings.defCountry);
    _city = _read(AppConstantKeys.keyCity, AppStrings.defCity);
    _latitude = _read<num>(AppConstantKeys.keyCurrentLatitude, AppStrings.defLatitude).toDouble();
    _longitude = _read<num>(AppConstantKeys.keyCurrentLongitude, AppStrings.defLongitude).toDouble();
    _calculationMethodIndex = _read(AppConstantKeys.keyCalculationIndex, 5);
    _highLatitudeMethodIndex = _read(AppConstantKeys.keyHighLatitudeIndex, 0);
    _asrMethodIndex = _read(AppConstantKeys.keyMadhabIndex, 0);
    _dst = _read(AppConstantKeys.keyDST, false);
    _hijriOffset = _read(AppConstantKeys.keyHijriOffset, 0);

    WidgetsBinding.instance.addObserver(this);
    initPrayerTime();
    _scheduleTick();
  }

  set setHijriOffset(int value) {
    final v = value.clamp(AppConstantKeys.minHijriOffset, AppConstantKeys.maxHijriOffset);
    if (v == _hijriOffset) return;
    _hijriOffset = v;
    _settingsPrayerTimeBox.put(AppConstantKeys.keyHijriOffset, v);
    notifyListeners(); // времена намазов не меняются, пересчёт не нужен
  }

  final Box _settingsPrayerTimeBox;

  static const Duration hourInterval = Duration(hours: 1);
  static const Duration _adhanWindow = Duration(minutes: 3);
  static const Duration _dhikrWindow = Duration(minutes: 30);
  static final DateFormat _hm = DateFormat('HH:mm');

  static const List<Prayer> _fivePrayers = [
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  static final Map<Prayer, String> _prayerNames = {
    Prayer.fajr: AppStrings.prayerFajr,
    Prayer.dhuhr: AppStrings.prayerDhuhr,
    Prayer.asr: AppStrings.prayerAsr,
    Prayer.maghrib: AppStrings.prayerMaghrib,
    Prayer.isha: AppStrings.prayerIsha,
  };

  static final Map<Prayer, String> _adjustmentKeys = {
    Prayer.fajr: AppConstantKeys.keyFajrAdjustment,
    Prayer.sunrise: AppConstantKeys.keySunriseAdjustment,
    Prayer.dhuhr: AppConstantKeys.keyDhuhrAdjustment,
    Prayer.asr: AppConstantKeys.keyAsrAdjustment,
    Prayer.maghrib: AppConstantKeys.keyMaghribAdjustment,
    Prayer.isha: AppConstantKeys.keyIshaAdjustment,
  };

  /// «Сейчас» с точностью до минуты. Времена adhan тоже округлены до минут,
  /// поэтому границы окон совпадают с тиками точно, а обратный отсчёт
  /// не теряет минуту из-за миллисекунд опоздания таймера.
  DateTime _dateTime = _nowMinute();
  Timer? _timer;

  late Coordinates _coordinates;
  late CalculationParameters _prayerParams;
  late Qibla _qibla;

  late _Day _yesterday, _today, _tomorrow;
  late List<_Moment> _prayers;
  late List<_Event> _events;

  late Map<Prayer, int> _adjustments;
  late String _country, _city;
  late double _latitude, _longitude;
  late int _calculationMethodIndex, _highLatitudeMethodIndex, _asrMethodIndex;
  late bool _dst;

  T _read<T>(String key, T defaultValue) =>
      _settingsPrayerTimeBox.get(key, defaultValue: defaultValue) as T;

  // ---------------------------------------------------------------------------
  // Расчёт
  // ---------------------------------------------------------------------------

  /// Полный пересчёт: старт и смена любых настроек.
  void initPrayerTime() {
    _coordinates = Coordinates(_latitude, _longitude);

    final offset = _dst ? 60 : 0;

    _prayerParams = AppStrings.prayerCalculationMethodList[_calculationMethodIndex].getParameters()
      ..highLatitudeRule = AppStrings.highLatitudeList[_highLatitudeMethodIndex]
      ..madhab = AppStrings.calculationMadhabList[_asrMethodIndex];
    _prayerParams.adjustments
      ..fajr = _adjustments[Prayer.fajr]! + offset
      ..sunrise = _adjustments[Prayer.sunrise]! + offset
      ..dhuhr = _adjustments[Prayer.dhuhr]! + offset
      ..asr = _adjustments[Prayer.asr]! + offset
      ..maghrib = _adjustments[Prayer.maghrib]! + offset
      ..isha = _adjustments[Prayer.isha]! + offset;

    _qibla = Qibla(_coordinates);
    _computeDays();
    notifyListeners();
  }

  /// Расчёт на произвольную дату (расписание, уведомления).
  PrayerTimes prayerTimeSchedule({required DateTime time}) =>
      PrayerTimes(_coordinates, DateComponents.from(time), _prayerParams);

  _Day _dayFor(DateTime date) {
    final times = prayerTimeSchedule(time: date);
    return (times: times, sunnah: SunnahTimes(times));
  }

  /// Вчера/сегодня/завтра и производные ряды. Раз в сутки или при смене настроек.
  void _computeDays() {
    final d = _dateTime;
    _yesterday = _dayFor(DateTime(d.year, d.month, d.day - 1));
    _today = _dayFor(DateTime(d.year, d.month, d.day));
    _tomorrow = _dayFor(DateTime(d.year, d.month, d.day + 1));

    // Вчерашний магриб — страховка для высоких широт, где 'иша может
    // перевалить за полночь и оказаться позже «сейчас».
    _prayers = [
      (prayer: Prayer.maghrib, time: _yesterday.times.maghrib),
      (prayer: Prayer.isha, time: _yesterday.times.isha),
      for (final p in _fivePrayers) (prayer: p, time: _today.times.timeForPrayer(p)!),
      (prayer: Prayer.fajr, time: _tomorrow.times.fajr),
    ];

    _events = [
      for (final (day, next) in [(_yesterday, _today), (_today, _tomorrow)]) ...[
        (
        name: AppStrings.midnight,
        time: day.sunnah.middleOfTheNight,
        anchor: day.times.sunrise,                 // было: day.times.maghrib
        ),
        (
        name: AppStrings.lastThirdNight,
        time: day.sunnah.lastThirdOfTheNight,
        anchor: day.sunnah.middleOfTheNight,
        ),
        (
        name: AppStrings.sunrise,
        time: next.times.sunrise,
        anchor: day.sunnah.lastThirdOfTheNight,    // было: next.times.fajr
        ),
      ],
    ];
  }

  // ---------------------------------------------------------------------------
  // Часы: тик в начале каждой минуты
  // ---------------------------------------------------------------------------

  static DateTime _nowMinute() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, n.hour, n.minute);
  }

  void _scheduleTick() {
    _timer?.cancel();
    final now = DateTime.now();
    final nextMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
    // Небольшой запас, чтобы гарантированно проснуться уже в новой минуте.
    _timer = Timer(nextMinute.difference(now) + const Duration(milliseconds: 50), () {
      _updateDateTime();
      _scheduleTick();
    });
  }

  void _updateDateTime() {
    final now = _nowMinute();
    if (now == _dateTime) return;

    final calendarChanged = now.day != _dateTime.day ||
        now.month != _dateTime.month ||
        now.year != _dateTime.year ||
        now.timeZoneOffset != _dateTime.timeZoneOffset;

    _dateTime = now;
    if (calendarChanged) _computeDays();
    notifyListeners();
  }

  // В PrayerState, рядом с остальными геттерами:
  Coordinates get coordinates => _coordinates;

  CalculationParameters get calculationParameters => _prayerParams;

  // ---------------------------------------------------------------------------
  // Текущее положение во времени
  // ---------------------------------------------------------------------------

  _Moment get _lastPrayer => _prayers.lastWhere((p) => !p.time.isAfter(_dateTime));

  _Moment get _nextPrayer => _prayers.firstWhere((p) => p.time.isAfter(_dateTime));

  _Event get _nextEvent => _events.firstWhere((e) => e.time.isAfter(_dateTime));

  bool get _beforeFajr => _dateTime.isBefore(_today.times.fajr);

  /// Расчёт, которому принадлежит текущая (или ближайшая) ночь.
  _Day get _night => _beforeFajr ? _yesterday : _today;

  /// Фаджр, которым эта ночь заканчивается.
  DateTime get _nightEnd => (_beforeFajr ? _today : _tomorrow).times.fajr;

  /// Полуинтервал [start; end): на границе активно ровно одно окно.
  bool _isWithinRange(DateTime start, DateTime end) =>
      !_dateTime.isBefore(start) && _dateTime.isBefore(end);

  /// Доля пройденного интервала [from; to], 0..1.
  double _fraction(DateTime from, DateTime to) {
    final total = to.difference(from).inSeconds;
    if (total <= 0) return 0;
    return (_dateTime.difference(from).inSeconds / total).clamp(0.0, 1.0);
  }

  // ---------------------------------------------------------------------------
  // Три круга главного экрана
  // ---------------------------------------------------------------------------

  /// Круг 1: последняя молитва и прошедшее с неё время. Прогресс 0→1.
  SleekEntity get elapsed {
    final last = _lastPrayer;
    return SleekEntity(
      name: _prayerNames[last.prayer]!,
      duration: _dateTime.difference(last.time),
      progress: _fraction(last.time, _nextPrayer.time),
    );
  }

  /// Круг 2: следующая молитва и остаток до неё. Прогресс 1→0.
  SleekEntity get remaining {
    final next = _nextPrayer;
    return SleekEntity(
      name: _prayerNames[next.prayer]!,
      duration: next.time.difference(_dateTime),
      progress: 1 - _fraction(_lastPrayer.time, next.time),
    );
  }

  /// Круг 3: ближайшее событие (восход / полночь / последняя треть).
  SleekEntity get event {
    final e = _nextEvent;
    return SleekEntity(
      name: e.name,
      duration: e.time.difference(_dateTime),
      progress: 1 - _fraction(e.anchor, e.time),
    );
  }

  int get currentPrayerStep {
    final passed = _fivePrayers
        .where((p) => !_today.times.timeForPrayer(p)!.isAfter(_dateTime))
        .length;
    return passed.clamp(0, _fivePrayers.length - 1);
  }

  /// Цикл начинается с восхода: до сегодняшнего восхода идёт вчерашний.
  int get currentEventStep {
    final day = _dateTime.isBefore(_today.times.sunrise) ? _yesterday : _today;
    final passed = [
      day.times.sunrise,
      day.sunnah.middleOfTheNight,
      day.sunnah.lastThirdOfTheNight,
    ].where((t) => !t.isAfter(_dateTime)).length;
    return passed.clamp(0, 2);
  }

  bool isNextPrayer({required Prayer prayer}) => _nextPrayer.prayer == prayer;

  // ---------------------------------------------------------------------------
  // Азкары. Порядок проверок = приоритет.
  // ---------------------------------------------------------------------------

  /// Индекс в `adhkarReminders` или null, если сейчас показывать нечего.
  int? get currentAdhkarIndex {
    // 0. Окно азана: ±3 минуты вокруг каждой молитвы.
    if (_prayers.any((p) => _isWithinRange(p.time.subtract(_adhanWindow), p.time.add(_adhanWindow)))) {
      return 0;
    }
    // 1. Поминания после молитвы: +3 → +30.
    if (_prayers.any((p) => _isWithinRange(p.time.add(_adhanWindow), p.time.add(_dhikrWindow)))) {
      return 1;
    }
    final t = _today.times;
    // 2. Утренние: фаджр+30 → зухр.
    if (_isWithinRange(t.fajr.add(_dhikrWindow), t.dhuhr)) return 2;
    // 3. Вечерние: 'аср+30 → магриб.
    if (_isWithinRange(t.asr.add(_dhikrWindow), t.maghrib)) return 3;
    // 4. Ночные: 'иша+30 → середина ночи (в том числе после 00:00).
    if (isNight) return 4;
    return null;
  }

  AdhkarReminder? get adhkarReminder {
    final index = currentAdhkarIndex;
    return index == null ? null : adhkarReminders[index];
  }

  bool isAdhan({required Prayer prayer}) {
    final t = _adhkarAnchor(prayer);
    return _isWithinRange(t.subtract(_adhanWindow), t.add(_adhanWindow));
  }

  bool isDhikr({required Prayer prayer}) {
    final t = _adhkarAnchor(prayer);
    return _isWithinRange(t.add(_adhanWindow), t.add(_dhikrWindow));
  }

  DateTime _adhkarAnchor(Prayer prayer) => _today.times.timeForPrayer(switch (prayer) {
    Prayer.none => Prayer.fajr,
    Prayer.sunrise => Prayer.dhuhr,
    _ => prayer,
  })!;

  // ---------------------------------------------------------------------------
  // Периоды суток
  // ---------------------------------------------------------------------------

  bool get isMorning => _isWithinRange(_today.times.fajr.add(_dhikrWindow), _today.times.sunrise);

  bool get isSunrise => _isWithinRange(_today.times.sunrise, _today.times.dhuhr);

  bool get isDuha => _isWithinRange(
    _today.times.sunrise.add(const Duration(minutes: 45)),
    _today.times.dhuhr.subtract(const Duration(minutes: 15)),
  );

  bool get isEvening => _isWithinRange(_today.times.asr.add(_dhikrWindow), _today.times.maghrib);

  bool get isNight =>
      _isWithinRange(_night.times.isha.add(_dhikrWindow), _night.sunnah.middleOfTheNight);

  bool get isMidnight =>
      _isWithinRange(_night.sunnah.middleOfTheNight, _night.sunnah.lastThirdOfTheNight);

  bool get isLastThird => _isWithinRange(_night.sunnah.lastThirdOfTheNight, _nightEnd);

  bool get isNightTime => _isWithinRange(_night.times.maghrib, _nightEnd);

  /// Исламская пятница: от магриба четверга до магриба пятницы.
  bool get isFriday => switch (_dateTime.weekday) {
    DateTime.thursday => !_dateTime.isBefore(_today.times.maghrib),
    DateTime.friday => _dateTime.isBefore(_today.times.maghrib),
    _ => false,
  };


  bool isPrayerInHourRange({required bool before, required DateTime prayerTime}) => before
      ? _isWithinRange(prayerTime.subtract(hourInterval), prayerTime)
      : _isWithinRange(prayerTime, prayerTime.add(hourInterval));

  // ---------------------------------------------------------------------------
  // Геттеры и форматирование
  // ---------------------------------------------------------------------------

  PrayerTimes get prayerTimes => _today.times;
  SunnahTimes get sunnahTimes => _today.sunnah;
  Qibla get qiblahDirection => _qibla;

  String get country => _country;
  String get city => _city;
  double get latitude => _latitude;
  double get longitude => _longitude;

  String formatTime(DateTime time) => _hm.format(time);

  String get gregorianDateText =>
      '${_dateTime.day} ${AppStrings.gregorianMonthsList[_dateTime.month - 1]}, ${_dateTime.year}';

  String get hijriDateText {
    final h = hijriFor(_dateTime);
    return '${h.hDay} ${AppStrings.hijriMonthsList[h.hMonth - 1]}, ${h.hYear}';
  }

  /// Без .abs(): при неверном выборе молитвы минус сразу виден в дебаге.
  String restPrayerTime({required bool isBefore, required DateTime time}) {
    var target = time;
    if (isBefore && !_dateTime.isBefore(target)) target = target.add(const Duration(days: 1));
    final d = isBefore ? target.difference(_dateTime) : _dateTime.difference(target);
    final h = d.inHours.remainder(24).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// [timeVariations]: [час, часа, часов, минута, минуты, минут].
  String fromFajrToMaghribFormatted({required List<String> timeVariations}) {
    final d = _today.times.maghrib.difference(_today.times.fajr);
    final v = timeVariations;
    return '${_pluralize(d.inHours, v[0], v[1], v[2])} '
        '${_pluralize(d.inMinutes.remainder(60), v[3], v[4], v[5])}';
  }

  static String _pluralize(int number, String one, String few, String many) {
    final n = number % 100;
    if (n >= 11 && n <= 14) return '$number $many';
    return switch (n % 10) {
      1 => '$number $one',
      2 || 3 || 4 => '$number $few',
      _ => '$number $many',
    };
  }

  late int _hijriOffset;

  int get hijriOffset => _hijriOffset;

  /// Дата хиджры для календарного дня с учётом смещения.
  HijriCalendar hijriFor(DateTime date) =>
  HijriCalendar.fromDate(DateTime(date.year, date.month, date.day + _hijriOffset));

  // ---------------------------------------------------------------------------
  // Настройки
  // ---------------------------------------------------------------------------

  Future<void> _persist(String key, Object value) async {
    await _settingsPrayerTimeBox.put(key, value);
    initPrayerTime();
  }

  Future<void> setLocation({
    required String country,
    required String city,
    required double latitude,
    required double longitude,
  }) async {
    _country = country;
    _city = city;
    _latitude = latitude;
    _longitude = longitude;
    initPrayerTime(); // UI обновляется сразу, запись — следом

    await _settingsPrayerTimeBox.putAll({
      AppConstantKeys.keyCountry: country,
      AppConstantKeys.keyCity: city,
      AppConstantKeys.keyCurrentLatitude: latitude,
      AppConstantKeys.keyCurrentLongitude: longitude,
    });
  }

  int get calculationMethodIndex => _calculationMethodIndex;

  set setCalculationIndex(int index) {
    if (index == _calculationMethodIndex) return;
    _calculationMethodIndex = index;
    _persist(AppConstantKeys.keyCalculationIndex, index);
  }

  int get highLatitudeMethodIndex => _highLatitudeMethodIndex;

  set setHighLatitudeIndex(int index) {
    if (index == _highLatitudeMethodIndex) return;
    _highLatitudeMethodIndex = index;
    _persist(AppConstantKeys.keyHighLatitudeIndex, index);
  }

  int get asrMethodIndex => _asrMethodIndex;

  set setAsrMethodIndex(int index) {
    if (index == _asrMethodIndex) return;
    _asrMethodIndex = index;
    _persist(AppConstantKeys.keyMadhabIndex, index);
  }

  bool get dst => _dst;

  set setDst(bool value) {
    if (value == _dst) return;
    _dst = value;
    _persist(AppConstantKeys.keyDST, value);
  }

  // ---------------------------------------------------------------------------
  // Ручные поправки по минутам
  // ---------------------------------------------------------------------------

  int get fajrAdjustment => _adjustments[Prayer.fajr]!;
  int get sunriseAdjustment => _adjustments[Prayer.sunrise]!;
  int get dhuhrAdjustment => _adjustments[Prayer.dhuhr]!;
  int get asrAdjustment => _adjustments[Prayer.asr]!;
  int get maghribAdjustment => _adjustments[Prayer.maghrib]!;
  int get ishaAdjustment => _adjustments[Prayer.isha]!;

  set fajrAdjustment(int v) => _setAdjustment(Prayer.fajr, v);
  set sunriseAdjustment(int v) => _setAdjustment(Prayer.sunrise, v);
  set dhuhrAdjustment(int v) => _setAdjustment(Prayer.dhuhr, v);
  set asrAdjustment(int v) => _setAdjustment(Prayer.asr, v);
  set maghribAdjustment(int v) => _setAdjustment(Prayer.maghrib, v);
  set ishaAdjustment(int v) => _setAdjustment(Prayer.isha, v);

  Future<void> _setAdjustment(Prayer prayer, int value) async {
    if (_adjustments[prayer] == value) return;
    _adjustments[prayer] = value;
    await _persist(_adjustmentKeys[prayer]!, value);
  }

  Future<void> resetAdjustments() async {
    if (_adjustments.values.every((v) => v == 0)) return;
    _adjustments.updateAll((_, _) => 0);
    await _settingsPrayerTimeBox.putAll({for (final key in _adjustmentKeys.values) key: 0});
    initPrayerTime();
  }

  // ---------------------------------------------------------------------------
  // Жизненный цикл
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // Закрывает и «ночь в фоне», и смену пояса, пока приложение спало.
        _updateDateTime();
        _scheduleTick();
      case AppLifecycleState.paused:
        _timer?.cancel();
        _timer = null;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}