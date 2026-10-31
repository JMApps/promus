import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class AppStrings {
  AppStrings._();

  static const String appName = 'ПроМус';

  static const String titleHome = 'Главная';
  static const String titleMushaf = 'Мусхаф';
  static const String titleFortress = 'Крепость';
  static const String titleCounter = 'Счётчик';

  static const String settings = 'Настройки';
  static const String params = 'Параметры';

  static const String searchByChapters = 'Поиск по главам';
  static const String searchBySurahs = 'Поиск по сурам';
  static const String startSearch = 'Начните поиск';
  static const String searchAyahs = 'Поиск аятов';
  static const String strShort = 'Стр.';
  static const String medina = 'Медина';
  static const String mecca = 'Мекка';
  static const String favorites = 'Избранное';
  static const String retry = 'Повторить';
  static const String lastSurahs = 'Последнее';
  static const String surahs = 'Суры';
  static const String surah = 'Сура';
  static const String ayah = 'Аят';
  static const String page = 'страница';
  static const String jumpToPage = 'Перейти к странице';
  static const String goTo = 'Перейти';
  static const String juz = 'джуз';
  static const String searchIsEmpty = 'По вашему запросу ничего не найдено';
  static const String errorLoadData = 'Ошибка загрузки данных';
  static const String reset = 'Сброс';
  static const String vibration = 'Цибрация';
  static const String showCountLabel = 'Показать количество';
  static const String countReset = 'Счётчик сброшен';
  static const String undo = 'Отменить';
  static const String cancel = 'Отмена';
  static const String select = 'Выбрать';

  static const String selectionCity = 'Выбор города';
  static const String selectCity = 'Выбрать город';
  static const String enterQuery = 'Введите запрос';

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

  static const String daysToRamadan = 'Дней до Рамадана';

  static const String loadData = 'Загрузка данных';
  static const String errorLoad = 'Ошибка загрузки';

  static const String morning = 'Утром';
  static const String evening = 'Вечером';
  static const String beforeSleep = 'Перед сном';
  static const String afterPrayer = 'После молитвы';
  static const String istikhara = 'Истихара';

  static const String copied = 'Скопировано';

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

  static const List<CalculationMethod> prayerCalculationMethods = [
    CalculationMethod.umm_al_qura,
    CalculationMethod.north_america,
    CalculationMethod.russia,
    CalculationMethod.tatarstan,
    CalculationMethod.dagestan,
    CalculationMethod.chechnya,
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
    'Dagestan',
    'Chechnya',
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

  static const List<String> tasbeehCounts = [
    '--/--',
    '33',
    '100',
    '1000',
  ];

  static String searchByQuery(String query, String matches) => 'По запросу «$query»\n$matches';

  static String searchError(String error) => 'Ошибка поиска: $error';
}
