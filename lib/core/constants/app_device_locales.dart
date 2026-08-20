import 'dart:ui';

class AppDeviceLocales {
  AppDeviceLocales._();

  static const List<Locale> appLocales = [
    Locale('ru'),
    Locale('kg'),
    Locale('uz'),
    Locale('az'),
    Locale('kk'),
  ];

  static const Map<String, int> defaultTranslationIndex = {
    'ru': 0,
    'kg': 1,
    'uz': 2,
    'az': 3,
    'kk': 4,
  };

  static const List<({String name, String column})> ayahTranslations = [
    (name: '[RU] Э. Кулиев', column: 'ayah_ru_kuliev'),
    (name: '[RU] Абу Адель', column: 'ayah_ru_adel'),
    (name: '[KG] Ш. Хакимов', column: 'ayah_kg'),
    (name: '[UZ] М. Содик', column: 'ayah_uz'),
    (name: '[AZ] А. Мусаев', column: 'ayah_az'),
    (name: '[KK] Х. Алтай', column: 'ayah_kk'),
  ];
}
