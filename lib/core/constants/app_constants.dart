import 'package:adhan/adhan.dart';

class AppConstants {
  AppConstants._();

  static const String keySettingsPrayerTimeBox = 'key_settings_prayer_time_box';

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
  static const String keyDST = 'key_dst';

  static const List<CalculationMethod> prayerCalculationMethods = [
    CalculationMethod.umm_al_qura,
    CalculationMethod.north_america,
    CalculationMethod.russia,
    CalculationMethod.tatarstan,
    CalculationMethod.france,
    CalculationMethod.dubai,
    CalculationMethod.egyptian,
    CalculationMethod.karachi,
    CalculationMethod.kuwait,
    CalculationMethod.moon_sighting_committee,
    CalculationMethod.muslim_world_league,
    CalculationMethod.qatar,
    CalculationMethod.turkey,
    CalculationMethod.singapore,
  ];

  static const List<HighLatitudeRule> highLatitude = [
    HighLatitudeRule.middle_of_the_night,
    HighLatitudeRule.seventh_of_the_night,
    HighLatitudeRule.twilight_angle,
  ];

  static const List<Madhab> calculationMadhab = [
    Madhab.shafi,
    Madhab.hanafi,
  ];

  static const List<String> prayerCalculationNames = [
    'Umm al-Qura',
    'North America (ISNA)',
    'Russia',
    'Tatarstan',
    'France',
    'Dubai',
    'Egyptian',
    'Karachi',
    'Kuwait',
    'Moon sighting committee (MSC)',
    'Muslim world league (MWL)',
    'Qatar',
    'Turkey',
    'Singapore',
  ];

  static const List<String> highLatitudeNames = [
    'Middle of the night',
    'Seventh of the night',
    'Twilight angle',
  ];

  static const List<String> asrMethodNames = [
    'Shafi',
    'Hanafi',
  ];

  static final List<Duration> calculationUtcOffset = [
    const Duration(hours: -1),
    const Duration(),
    const Duration(hours: 1),
  ];

  static const List<String> gregorianMonths = <String>[
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  static const List<String> hijriMonths = <String>[
    'мухаррам',
    'сафар',
    'раби аль-авваль',
    'раби ас-сани',
    'джумада аль-уля',
    'джумада ас-сани',
    'раджаб',
    'шаабан',
    'рамадан',
    'шавваль',
    'зуль-каада',
    'зуль-хиджа',
  ];

  static const List<String> adhkarList = [
    'Слова поминания во время азана',
    'Слова поминания после молитвы',
    'Время утренних азкаров',
    'Время вечерних азкаров',
    'Время ночных азкаров',
  ];

  static const String mainAppSettingsBox = 'main_app_settings_box';
  static const String mainBookmarksBox = 'main_bookmarks_box';

  static const String keyLastOpenedPages = 'key_last_opened_pages';
  static const String keyFavoritePages = 'key_favorite_pages';
  static const String keyFavoriteAyahs = 'key_favorite_ayahs';

  static const String keyAppLocaleIndex = 'key_app_locale_index';
  static const String keyTranslationNameIndex = 'key_translation_name_index';
  static const String keySurahArabicName = 'key_surah_arabic_name';
  static const String keyTranslationNameSurah = 'key_translation_surah_name';
  static const String keyAlwaysDisplayOn = 'key_always_display_on';
  static const String keyAppThemeModeIndex = 'key_app_theme_mode_index';
  static const String keyAppThemeColor = 'key_app_theme_color';

  static const String keyShowArabicAyah = 'key_show_arabic_ayah';
  static const String keyShowTranslationAyah = 'key_show_translation_ayah';
  static const String keyAyahArabicTextSize = 'key_ayah_arabic_text_size';
  static const String keyAyahTranslationTextSize = 'key_ayah_translation_text_size';
}
