import 'package:adhan/adhan.dart';

import '../../../../core/enums/prayer_labels.dart';
import '../../../../core/services/models.dart';
import '../../../../core/utils/high_latitude.dart';

class AdhanPrayerTimesSource implements PrayerTimesSource {
  AdhanPrayerTimesSource(this.coordinates, this.params);

  final Coordinates coordinates;
  final CalculationParameters params;

  @override
  DayPrayerTimes timesFor(DateTime date) {
    // Не падает в полярный день/ночь: там считает по широте 65°.
    final t = HighLatitude.prayerTimes(coordinates, DateComponents.from(date), params).times;
    return {
      PrayerLabels.fajr: t.fajr,
      PrayerLabels.sunrise: t.sunrise,
      PrayerLabels.dhuhr: t.dhuhr,
      PrayerLabels.asr: t.asr,
      PrayerLabels.maghrib: t.maghrib,
      PrayerLabels.isha: t.isha,
    };
  }
}