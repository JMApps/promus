import 'package:adhan/adhan.dart';

import '../../../../core/enums/prayer_labels.dart';
import '../../../../core/services/models.dart';

class AdhanPrayerTimesSource implements PrayerTimesSource {
  AdhanPrayerTimesSource(this.coordinates, this.params);

  final Coordinates coordinates;
  final CalculationParameters params;

  @override
  DayPrayerTimes timesFor(DateTime date) {
    final t = PrayerTimes(coordinates, DateComponents.from(date), params);
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