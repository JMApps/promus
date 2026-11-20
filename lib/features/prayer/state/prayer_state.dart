import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/adhkar_reminders.dart';
import '../../../core/constants/app_prayer_keys.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/enums/dst_format_mode.dart';
import '../../../core/enums/time_format_mode.dart';
import '../../../core/utils/high_latitude.dart';
import '../domain/entities/prayer_records.dart';
import '../domain/entities/sleek_entity.dart';

class PrayerState extends ChangeNotifier with WidgetsBindingObserver {
  PrayerState({required this._settingsPrayerTimeBox}) {
    _adjustments = {
      for (final e in AppPrayerKeys.adjustmentKeys.entries) e.key: _read<int>(e.value, 0),
    };
    _calculationMethodIndex = _read<int>(AppPrayerKeys.keyCalculationIndex, 5).clamp(0, AppPrayerKeys.prayerCalculationMethodList.length - 1);
    _highLatitudeMethodIndex = _read<int>(AppPrayerKeys.keyHighLatitudeIndex, AppPrayerKeys.highLatitudeAutoIndex).clamp(0, AppPrayerKeys.highLatitudeList.length - 1);
    _asrMethodIndex = _read<int>(AppPrayerKeys.keyMadhabIndex, 0).clamp(0, AppPrayerKeys.calculationMadhabList.length - 1);
    _dstMode = _readDstMode();
    _country = _read(AppPrayerKeys.keyCountry, AppPrayerKeys.defCountry);
    _city = _read(AppPrayerKeys.keyCity, AppPrayerKeys.defCity);
    _latitude = _read<num>(AppPrayerKeys.keyCurrentLatitude, AppPrayerKeys.defLatitude).toDouble();
    _longitude = _read<num>(AppPrayerKeys.keyCurrentLongitude, AppPrayerKeys.defLongitude).toDouble();
    _hijriOffset = _read(AppPrayerKeys.keyHijriOffset, 0);
    _timeFormatMode = TimeFormatMode.values[
    _read<int>(AppPrayerKeys.keyTimeFormat, 0).clamp(0, TimeFormatMode.values.length - 1)];
    _resolveTimeFormat();

    WidgetsBinding.instance.addObserver(this);
    initPrayerTime();
    _scheduleTick();
  }

  // ---------------------------------------------------------------------------
  // Поля
  // ---------------------------------------------------------------------------

  final Box _settingsPrayerTimeBox;

  /// «Сейчас» с точностью до минуты.
  DateTime _dateTime = _nowMinute();
  Timer? _timer;

  // Расчёт
  late Coordinates _coordinates;
  late CalculationParameters _prayerParams;
  late Qibla _qibla;
  late PrayerDay _yesterday, _today, _tomorrow;
  late List<PrayerMoment> _prayers;
  late List<NightEvent> _events;

  // Настройки
  late String _country, _city;
  late double _latitude, _longitude;
  late int _calculationMethodIndex, _highLatitudeMethodIndex, _asrMethodIndex;
  late DSTFormatMode _dstMode;
  late int _hijriOffset;
  late Map<Prayer, int> _adjustments;

  T _read<T>(String key, T defaultValue) => _settingsPrayerTimeBox.get(key, defaultValue: defaultValue) as T;

  late TimeFormatMode _timeFormatMode;
  bool _use24HourFormat = true;

  // ---------------------------------------------------------------------------
  // Результаты расчёта
  // ---------------------------------------------------------------------------

  PrayerTimes get prayerTimes => _today.times;

  SunnahTimes get sunnahTimes => _today.sunnah;

  Qibla get qiblahDirection => _qibla;

  // [ПРОВЕРИТЬ] Если снаружи из них собирают PrayerTimes вручную —
  // это [ДУБЛЬ] prayerTimeSchedule(), лучше вызывать его.
  Coordinates get coordinates => _coordinates;

  CalculationParameters get calculationParameters => _prayerParams;

  // ---------------------------------------------------------------------------
  // Расчёт
  // ---------------------------------------------------------------------------

  /// Полный пересчёт: старт и смена любых настроек.
  /// Полный пересчёт: старт и смена любых настроек.
  void initPrayerTime() {
    _coordinates = Coordinates(_latitude, _longitude);

    final offset = switch (_dstMode) {
      DSTFormatMode.system => 0,
      DSTFormatMode.minusHour => -60,
      DSTFormatMode.plusHour => 60,
    };

    final params = AppPrayerKeys.prayerCalculationMethodList[_calculationMethodIndex].getParameters()
      ..madhab = AppPrayerKeys.calculationMadhabList[_asrMethodIndex];

    // Ниже предела широты правило ничего не меняет, поэтому выбор пользователя
    // там не применяем. null в списке означает «Авто», то есть 1/7 ночи.
    _prayerParams = params
      ..highLatitudeRule = HighLatitude.effectiveRule(
        _latitude,
        params,
        AppPrayerKeys.highLatitudeList[_highLatitudeMethodIndex],
      );

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
      HighLatitude.prayerTimes(_coordinates, DateComponents.from(time), _prayerParams).times;

  PrayerDay _dayFor(DateTime date) {
    final d = DateComponents.from(date);
    try {
      final times = PrayerTimes(_coordinates, d, _prayerParams);
      return (times: times, sunnah: SunnahTimes(times), polar: false);
    } on ArgumentError {
      // Полярный день/ночь. SunnahTimes тоже считает «завтра» и может упасть
      // даже при удачном PrayerTimes, поэтому в try обёрнуты оба.
      final times = PrayerTimes(HighLatitude.polarFallback(_coordinates), d, _prayerParams);
      return (times: times, sunnah: SunnahTimes(times), polar: true);
    }
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
      for (final p in AppPrayerKeys.fivePrayers) (prayer: p, time: _today.times.timeForPrayer(p)!),
      (prayer: Prayer.fajr, time: _tomorrow.times.fajr),
    ];

    _events = [
      for (final (day, next) in [(_yesterday, _today), (_today, _tomorrow)]) ...[
        (
        name: AppStrings.midnight,
        time: day.sunnah.middleOfTheNight,
        anchor: day.times.sunrise,
        ),
        (
        name: AppStrings.lastThirdNight,
        time: day.sunnah.lastThirdOfTheNight,
        anchor: day.sunnah.middleOfTheNight,
        ),
        (
        name: AppStrings.sunrise,
        time: next.times.sunrise,
        anchor: day.sunnah.lastThirdOfTheNight,
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

  // ---------------------------------------------------------------------------
  // Текущее положение во времени
  // ---------------------------------------------------------------------------

  PrayerMoment get _lastPrayer => _prayers.lastWhere((p) => !p.time.isAfter(_dateTime));

  PrayerMoment get _nextPrayer => _prayers.firstWhere((p) => p.time.isAfter(_dateTime));

  NightEvent get _nextEvent => _events.firstWhere((e) => e.time.isAfter(_dateTime));

  bool get _beforeFajr => _dateTime.isBefore(_today.times.fajr);

  /// Расчёт, которому принадлежит текущая (или ближайшая) ночь.
  PrayerDay get _night => _beforeFajr ? _yesterday : _today;

  /// Полуинтервал [start; end): на границе активно ровно одно окно.
  bool _isWithinRange(DateTime start, DateTime end) => !_dateTime.isBefore(start) && _dateTime.isBefore(end);

  /// Доля пройденного интервала [from; to], 0..1.
  double _fraction(DateTime from, DateTime to) {
    final total = to.difference(from).inSeconds;
    if (total <= 0) return 0;
    return (_dateTime.difference(from).inSeconds / total).clamp(0.0, 1.0);
  }

  // ---------------------------------------------------------------------------
  // Три круга и степперы главного экрана
  // ---------------------------------------------------------------------------

  /// Круг 1: последняя молитва и прошедшее с неё время. Прогресс 0→1.
  SleekEntity get elapsedPrayerTime {
    final last = _lastPrayer;
    return SleekEntity(
      name: AppPrayerKeys.prayerNames[last.prayer]!,
      duration: _dateTime.difference(last.time),
      progress: _fraction(last.time, _nextPrayer.time),
    );
  }

  /// Круг 2: следующая молитва и остаток до неё. Прогресс 1→0.
  SleekEntity get remainingPrayerTime {
    final next = _nextPrayer;
    return SleekEntity(
      name: AppPrayerKeys.prayerNames[next.prayer]!,
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

  /// Индекс следующей молитвы. 30 минут после азана 'иша все шаги
  /// показываются пройденными, затем — завтрашний фаджр.
  int get currentPrayerStep {
    final last = _lastPrayer;
    if (last.prayer == Prayer.isha && _dateTime.isBefore(last.time.add(AppPrayerKeys.dhikrWindow))) {
      return AppPrayerKeys.fivePrayers.length;
    }
    return AppPrayerKeys.fivePrayers.indexOf(_nextPrayer.prayer);
  }

  /// Шаг степпера «Восход → Полночь → 1/3 ночи».
  /// Последняя треть до фаджра — все шаги пройдены; после фаджра активен восход.
  int get currentEventStep => switch (_nextEvent.name) {
    AppStrings.midnight => 1,
    AppStrings.lastThirdNight => 2,
    _ when _nextPrayer.prayer == Prayer.fajr => 3,
    _ => 0,
  };

  // ---------------------------------------------------------------------------
  // Азкары. Порядок проверок = приоритет.
  // ---------------------------------------------------------------------------

  /// Индекс в `adhkarReminders` или null, если сейчас показывать нечего.
  int? get currentAdhkarIndex {
    // 0. Окно азана: ±3 минуты вокруг каждой молитвы.
    if (_prayers.any((p) => _isWithinRange(
      p.time.subtract(AppPrayerKeys.adhanWindow),
      p.time.add(AppPrayerKeys.adhanWindow),
    ))) {
      return 0;
    }
    // 1. Поминания после молитвы: +3 → +30.
    if (_prayers.any((p) => _isWithinRange(
      p.time.add(AppPrayerKeys.adhanWindow),
      p.time.add(AppPrayerKeys.dhikrWindow),
    ))) {
      return 1;
    }
    final t = _today.times;
    // 2. Утренние: фаджр+30 → зухр.
    if (_isWithinRange(t.fajr.add(AppPrayerKeys.dhikrWindow), t.dhuhr)) return 2;
    // 3. Вечерние: 'аср+30 → магриб.
    if (_isWithinRange(t.asr.add(AppPrayerKeys.dhikrWindow), t.maghrib)) return 3;
    // 4. Ночные: 'иша+30 → середина ночи. После 00:00 _night — вчерашний расчёт.
    final n = _night;
    if (_isWithinRange(n.times.isha.add(AppPrayerKeys.dhikrWindow), n.sunnah.middleOfTheNight)) return 4;
    return null;
  }

  AdhkarReminder? get adhkarReminder {
    final index = currentAdhkarIndex;
    return index == null ? null : adhkarReminders[index];
  }

  /// Исламская пятница: от магриба четверга до магриба пятницы.
  bool get isFriday => switch (_dateTime.weekday) {
    DateTime.thursday => !_dateTime.isBefore(_today.times.maghrib),
    DateTime.friday => _dateTime.isBefore(_today.times.maghrib),
    _ => false,
  };

  /// Последний час пятницы: за час до магриба и до самого магриба.
  bool get isFridayLastHour => _dateTime.weekday == DateTime.friday && _isWithinRange(_today.times.maghrib.subtract(AppPrayerKeys.hourInterval), _today.times.maghrib);

  // ---------------------------------------------------------------------------
  // Даты и форматирование
  // ---------------------------------------------------------------------------

  TimeFormatMode get timeFormatMode => _timeFormatMode;

  bool get use24HourFormat => _use24HourFormat;

  void _resolveTimeFormat() {
    _use24HourFormat = switch (_timeFormatMode) {
      TimeFormatMode.system =>
      WidgetsBinding.instance.platformDispatcher.alwaysUse24HourFormat,
      TimeFormatMode.h24 => true,
      TimeFormatMode.h12 => false,
    };
  }

  String formatTime(DateTime time, {bool compact = false}) {
    if (_use24HourFormat) return AppPrayerKeys.hMDateFormat.format(time);
    return (compact ? AppPrayerKeys.hMDateFormat12Compact : AppPrayerKeys.hMDateFormat12).format(time);
  }

  set setTimeFormatMode(TimeFormatMode mode) {
    if (mode == _timeFormatMode) return;
    _timeFormatMode = mode;
    _resolveTimeFormat();
    unawaited(_settingsPrayerTimeBox.put(AppPrayerKeys.keyTimeFormat, mode.index));
    notifyListeners();
  }

  String get gregorianDateText => '${_dateTime.day} ${AppStrings.gregorianMonthsList[_dateTime.month - 1]}, ${_dateTime.year}';

  String get hijriDateText {
    final h = hijriFor(_dateTime);
    return '${h.hDay} ${AppStrings.hijriMonthsList[h.hMonth - 1]}, ${h.hYear}';
  }

  /// Дата хиджры для календарного дня с учётом смещения.
  HijriCalendar hijriFor(DateTime date) => HijriCalendar.fromDate(DateTime(date.year, date.month, date.day + _hijriOffset));

  // ---------------------------------------------------------------------------
  // Настройки
  // ---------------------------------------------------------------------------

  Future<void> _persist(String key, Object value) async {
    await _settingsPrayerTimeBox.put(key, value);
    initPrayerTime();
  }

  String get country => _country;

  String get city => _city;

  double get latitude => _latitude;

  double get longitude => _longitude;

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
      AppPrayerKeys.keyCountry: country,
      AppPrayerKeys.keyCity: city,
      AppPrayerKeys.keyCurrentLatitude: latitude,
      AppPrayerKeys.keyCurrentLongitude: longitude,
    });
  }

  int get calculationMethodIndex => _calculationMethodIndex;

  set setCalculationIndex(int index) {
    if (index == _calculationMethodIndex) return;
    _calculationMethodIndex = index;
    unawaited(_persist(AppPrayerKeys.keyCalculationIndex, index));
  }

  int get highLatitudeMethodIndex => _highLatitudeMethodIndex;

  set setHighLatitudeIndex(int index) {
    if (index == _highLatitudeMethodIndex) return;
    _highLatitudeMethodIndex = index;
    unawaited(_persist(AppPrayerKeys.keyHighLatitudeIndex, index));
  }

  int get asrMethodIndex => _asrMethodIndex;

  set setAsrMethodIndex(int index) {
    if (index == _asrMethodIndex) return;
    _asrMethodIndex = index;
    unawaited(_persist(AppPrayerKeys.keyMadhabIndex, index));
  }

  DSTFormatMode get dstMode => _dstMode;

  set setDstMode(DSTFormatMode mode) {
    if (mode == _dstMode) return;
    _dstMode = mode;
    unawaited(_persist(AppPrayerKeys.keyDSTMode, mode.index));
  }

  DSTFormatMode _readDstMode() {
    final stored = _settingsPrayerTimeBox.get(AppPrayerKeys.keyDSTMode);
    if (stored is int) {
      return DSTFormatMode.values[stored.clamp(0, DSTFormatMode.values.length - 1)];
    }
    return _read(AppPrayerKeys.keyDSTMode, false) ? DSTFormatMode.plusHour : DSTFormatMode.system;
  }

  int get hijriOffset => _hijriOffset;

  /// [ПРОВЕРИТЬ] Нужен экрану настроек; если UI смещения хиджры нет — удалить.
  set setHijriOffset(int value) {
    final v = value.clamp(AppPrayerKeys.minHijriOffset, AppPrayerKeys.maxHijriOffset);
    if (v == _hijriOffset) return;
    _hijriOffset = v;
    unawaited(_settingsPrayerTimeBox.put(AppPrayerKeys.keyHijriOffset, v));
    notifyListeners(); // меняется только дата хиджры; initPrayerTime() не нужен
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

  set fajrAdjustment(int v) => unawaited(_setAdjustment(Prayer.fajr, v));

  set sunriseAdjustment(int v) => unawaited(_setAdjustment(Prayer.sunrise, v));

  set dhuhrAdjustment(int v) => unawaited(_setAdjustment(Prayer.dhuhr, v));

  set asrAdjustment(int v) => unawaited(_setAdjustment(Prayer.asr, v));

  set maghribAdjustment(int v) => unawaited(_setAdjustment(Prayer.maghrib, v));

  set ishaAdjustment(int v) => unawaited(_setAdjustment(Prayer.isha, v));

  Future<void> _setAdjustment(Prayer prayer, int value) async {
    final v = value.clamp(-AppPrayerKeys.maxAdjustmentMinutes, AppPrayerKeys.maxAdjustmentMinutes);
    if (_adjustments[prayer] == v) return;
    _adjustments[prayer] = v;
    await _persist(AppPrayerKeys.adjustmentKeys[prayer]!, v);
  }

  Future<void> resetAdjustments() async {
    if (_adjustments.values.every((v) => v == 0)) return;
    _adjustments.updateAll((_, _) => 0);
    await _settingsPrayerTimeBox.putAll({
      for (final key in AppPrayerKeys.adjustmentKeys.values) key: 0,
    });
    initPrayerTime();
  }

  // ---------------------------------------------------------------------------
  // Жизненный цикл
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        final wasUse24 = _use24HourFormat;
        _resolveTimeFormat();
        if (wasUse24 != _use24HourFormat) notifyListeners();
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