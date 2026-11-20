import 'dart:math' as math;

import 'package:adhan/adhan.dart';

/// Высокие широты: какое правило применять и что делать в полярный день/ночь.
abstract final class HighLatitude {
  static const double _axialTilt = 23.44;

  /// Ближайшая к полюсу широта, где солнце восходит и заходит круглый год
  /// (полярный круг 66,56° с поправкой на рефракцию).
  static const double polarFallbackLatitude = 65.0;

  /// Выше этой широты летом сумерки не заканчиваются: Фаджр и 'Иша по углу
  /// не существуют. Для 18° — ≈48,6°, для 15° — ≈51,6°.
  static double twilightLimit(CalculationParameters p) => 90 - _axialTilt - math.max(p.fajrAngle, p.ishaAngle ?? 0);

  static bool needsRule(double latitude, CalculationParameters p) => latitude.abs() > twilightLimit(p);

  /// [chosen] == null — «Авто».
  /// Ниже предела «середина ночи» ничего не меняет, поэтому выбор пользователя
  /// там не применяем: иначе «1/7» сдвигает летний Фаджр на час позже реального.
  static HighLatitudeRule effectiveRule(double latitude, CalculationParameters p, HighLatitudeRule? chosen) {
    if (!needsRule(latitude, p)) return .middle_of_the_night;
    // У методов с интервалом для 'Иши (Умм аль-Кура, Катар) нет угла 'Иши,
    // и twilight_angle в adhan бросает FormatException.
    if (chosen == .twilight_angle && p.ishaAngle == null) return .seventh_of_the_night;
    return chosen ?? .seventh_of_the_night;
  }

  static Coordinates polarFallback(Coordinates c) => Coordinates(c.latitude.clamp(-polarFallbackLatitude, polarFallbackLatitude), c.longitude);

  /// Никогда не бросает: в полярный день/ночь считает по [polarFallbackLatitude].
  static ({PrayerTimes times, bool polar}) prayerTimes(Coordinates c, DateComponents d, CalculationParameters p) {
    try {
      return (times: PrayerTimes(c, d, p), polar: false);
    } on ArgumentError {
      return (times: PrayerTimes(polarFallback(c), d, p), polar: true);
    }
  }
}