import 'calculation_parameters.dart';
import 'prayer_adjustments.dart';

enum CalculationMethod {
  muslim_world_league,
  egyptian,
  russia,
  tatarstan,
  france,
  dagestan,
  chechnya,
  karachi,
  umm_al_qura,
  dubai,
  moon_sighting_committee,
  north_america,
  kuwait,
  qatar,
  singapore,
  turkey,
  tehran,
  other
}

extension CalculationMethodExtensions on CalculationMethod {
  CalculationParameters getParameters() {
    switch (this) {
      case CalculationMethod.russia:
        {
          return CalculationParameters(
              fajrAngle: 16.0, ishaAngle: 15.0, method: this);
        }
      case CalculationMethod.tatarstan:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 17.0, method: this);
        }
      case CalculationMethod.dagestan:
        {
          return CalculationParameters(
              fajrAngle: 17.5, ishaAngle: 15.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 2,
              sunrise: -4,
              dhuhr: 5,
              asr: 4,
              maghrib: 3,
              isha: 2));
        }
      case CalculationMethod.chechnya:
        {
          return CalculationParameters(
              fajrAngle: 16.0, ishaAngle: 15.0, method: this)
              .withMethodAdjustments(
              PrayerAdjustments(
                  fajr: 0,
                  sunrise: 0,
                  dhuhr: 0,
                  asr: 1,
                  maghrib: 0,
                  isha: 0));
        }
      case CalculationMethod.north_america:
        {
          return CalculationParameters(
              fajrAngle: 15.0, ishaAngle: 15.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: 0,
              dhuhr: 1,
              asr: 0,
              maghrib: 0,
              isha: 0));
        }
      case CalculationMethod.muslim_world_league:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 17.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: 0,
              dhuhr: 1,
              asr: 0,
              maghrib: 0,
              isha: 0));
        }
      case CalculationMethod.umm_al_qura:
        {
          return CalculationParameters(
              fajrAngle: 18.5, ishaInterval: 90, method: this);
        }
      case CalculationMethod.france:
        {
          return CalculationParameters(
              fajrAngle: 12.0, ishaAngle: 12.0, method: this);
        }
      case CalculationMethod.dubai:
        {
          return CalculationParameters(
              fajrAngle: 18.2, ishaAngle: 18.2, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: -3,
              dhuhr: 3,
              asr: 3,
              maghrib: 3,
              isha: 0));
        }
      case CalculationMethod.egyptian:
        {
          return CalculationParameters(
              fajrAngle: 19.5, ishaAngle: 17.5, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: 0,
              dhuhr: 1,
              asr: 0,
              maghrib: 0,
              isha: 0));
        }
      case CalculationMethod.karachi:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: 0,
              dhuhr: 1,
              asr: 0,
              maghrib: 0,
              isha: 0));
        }
      case CalculationMethod.kuwait:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 17.5, method: this);
        }
      case CalculationMethod.moon_sighting_committee:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: 0,
              dhuhr: 5,
              asr: 0,
              maghrib: 3,
              isha: 0));
        }
      case CalculationMethod.qatar:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaInterval: 90, method: this);
        }
      case CalculationMethod.turkey:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 17.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: -7,
              dhuhr: 5,
              asr: 4,
              maghrib: 7,
              isha: 0));
        }
      case CalculationMethod.singapore:
        {
          return CalculationParameters(
              fajrAngle: 20.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
              fajr: 0,
              sunrise: 0,
              dhuhr: 1,
              asr: 0,
              maghrib: 0,
              isha: 0));
        }
      case CalculationMethod.tehran:
        {
          return CalculationParameters(
            fajrAngle: 17.7,
            ishaAngle: 14,
            maghribAngle: 4.5,
            method: this,
          );
        }
      case CalculationMethod.other:
        {
          return CalculationParameters(
              fajrAngle: 0.0, ishaAngle: 0.0, method: this);
        }
      default:
        {
          throw FormatException('Invalid CalculationMethod');
        }
    }
  }
}
