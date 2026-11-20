import 'package:adhan/adhan.dart';

/// Расчёт одних календарных суток.
typedef PrayerDay = ({PrayerTimes times, SunnahTimes sunnah, bool polar});

/// Момент молитвы в общем ряду «вчера → сегодня → завтра».
typedef PrayerMoment = ({Prayer prayer, DateTime time});

/// Событие третьего круга. [anchor] — откуда считается прогресс.
typedef NightEvent = ({String name, DateTime time, DateTime anchor});
