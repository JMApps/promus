import '../constants/app_strings.dart';

enum PrayerLabels {
  fajr(AppStrings.prayerFajr),
  sunrise(AppStrings.sunriseDuha),
  dhuhr(AppStrings.prayerDhuhr),
  asr(AppStrings.prayerAsr),
  maghrib(AppStrings.prayerMaghrib),
  isha(AppStrings.prayerIsha);

  const PrayerLabels(this.label);

  final String label;

  bool get hasIkamah => withIkamah.contains(this);
  
  static const withIkamah = [fajr, dhuhr, asr, maghrib, isha];
}
