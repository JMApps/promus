import '../constants/app_strings.dart';

enum PrayerLabels {
  fajr(AppStrings.prayerFajr),
  sunrise(AppStrings.sunrise),
  dhuhr(AppStrings.prayerDhuhr),
  asr(AppStrings.prayerAsr),
  maghrib(AppStrings.prayerMaghrib),
  isha(AppStrings.prayerIsha);

  const PrayerLabels(this.label);

  final String label;

  bool get hasIqamah => withIqamah.contains(this);
  
  static const withIqamah = [fajr, dhuhr, asr, maghrib, isha];
}
