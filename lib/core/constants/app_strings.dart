import 'package:intl/intl.dart';

class AppStrings {
  AppStrings._();

  static const String appName = 'ПроМус';

  static const String titleHome = 'Главная';
  static const String titleMushaf = 'Мусхаф';
  static const String titleFortress = 'Крепость';
  static const String titleCounter = 'Счётчик';

  static const String searchByChapters = 'Поиск по главам';
  static const String searchBySurahs = 'Поиск по сурам';

  static const List weekDays = <String>[
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  static const String prayerFajr = 'Фаджр';
  static const String prayerDhuhr = 'Зухр';
  static const String prayerAsr = '\'Аср';
  static const String prayerMaghrib = 'Магриб';
  static const String prayerIsha = '\'Иша';

  static const String sunrise = 'Восход';
  static const String midnight = 'Полночь';
  static const String lastThirdNight = 'Треть';

  static String ayahsCount(int count) => Intl.plural(
    count,
    one: '$count аят',
    few: '$count аята',
    many: '$count аятов',
    other: '$count аята',
    locale: 'ru',
  );

  static String searchResults(int count) => Intl.plural(
    count,
    zero: 'ничего не найдено',
    one: 'найден $count результат',
    few: 'найдено $count результата',
    many: 'найдено $count результатов',
    other: 'Найдено $count результата',
    locale: 'ru',
  );

  static String searchByQuery(String query, String matches) =>
      'По запросу «$query»\n$matches';
  static String searchError(String error) => 'Ошибка поиска: $error';
}
