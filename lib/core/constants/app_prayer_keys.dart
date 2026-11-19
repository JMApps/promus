import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

import 'app_strings.dart';

class AppPrayerKeys {
  static const String keyFajrAdjustment = 'key_fajr_adjustment';
  static const String keySunriseAdjustment = 'key_sunrise_adjustment';
  static const String keyDhuhrAdjustment = 'key_dhuhr_adjustment';
  static const String keyAsrAdjustment = 'key_asr_adjustment';
  static const String keyMaghribAdjustment = 'key_maghrib_adjustment';
  static const String keyIshaAdjustment = 'key_isha_adjustment';

  static const String keyCountry = 'key_country';
  static const String keyCity = 'key_city';
  static const String keyCurrentLatitude = 'key_current_latitude';
  static const String keyCurrentLongitude = 'key_current_longitude';
  static const String keyCalculationIndex = 'key_calculation_index';
  static const String keyHighLatitudeIndex = 'key_high_latitude_index';
  static const String keyMadhabIndex = 'key_madhab_index';
  static const String keyDSTMode = 'key_dst_mode';

  static const String keyTimeFormat = 'key_time_format';

  static final DateFormat hMDateFormat = DateFormat('HH:mm');
  static final DateFormat hMDateFormat12 = DateFormat('h:mm a');
  static final DateFormat hMDateFormat12Compact = DateFormat('h:mm');

  static const String keyHijriOffset = 'key_hijri_offset';
  static const int minHijriOffset = -2;
  static const int maxHijriOffset = 2;

  static const int maxAdjustmentMinutes = 60;
  static const int maxIqamahMinutes = 60;

  static const String defCity = 'Mecca';
  static const String defCountry = 'Saudi Arabia';
  static const double defLatitude = 21.42580;
  static const double defLongitude = 39.82410;

  static const List<CalculationMethod> prayerCalculationMethodList = [
    CalculationMethod.russia,
    CalculationMethod.tatarstan,
    CalculationMethod.dagestan,
    CalculationMethod.chechnya,
    CalculationMethod.north_america,
    CalculationMethod.muslim_world_league,
    CalculationMethod.umm_al_qura,
    CalculationMethod.france,
    CalculationMethod.dubai,
    CalculationMethod.egyptian,
    CalculationMethod.karachi,
    CalculationMethod.kuwait,
    CalculationMethod.moon_sighting_committee,
    CalculationMethod.qatar,
    CalculationMethod.turkey,
    CalculationMethod.singapore,
  ];

  static const List<HighLatitudeRule> highLatitudeList = [
    HighLatitudeRule.middle_of_the_night,
    HighLatitudeRule.seventh_of_the_night,
    HighLatitudeRule.twilight_angle,
  ];

  static const List<Madhab> calculationMadhabList = [
    Madhab.shafi,
    Madhab.hanafi,
  ];

  static const Duration hourInterval = Duration(hours: 1);
  static const Duration adhanWindow = Duration(minutes: 3);
  static const Duration dhikrWindow = Duration(minutes: 30);

  static const List<Prayer> fivePrayers = [
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  static const Map<Prayer, String> prayerNames = {
    Prayer.fajr: AppStrings.prayerFajr,
    Prayer.dhuhr: AppStrings.prayerDhuhr,
    Prayer.asr: AppStrings.prayerAsr,
    Prayer.maghrib: AppStrings.prayerMaghrib,
    Prayer.isha: AppStrings.prayerIsha,
  };

  static const Map<Prayer, String> adjustmentKeys = {
    Prayer.fajr: keyFajrAdjustment,
    Prayer.sunrise: keySunriseAdjustment,
    Prayer.dhuhr: keyDhuhrAdjustment,
    Prayer.asr: keyAsrAdjustment,
    Prayer.maghrib: keyMaghribAdjustment,
    Prayer.isha: keyIshaAdjustment,
  };
}