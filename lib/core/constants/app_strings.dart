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

  static const String alwaysOnDisplay = 'Дисплей всегда включён';
  static const String theme = 'Тема';
  static const String themeSystem = 'Системная';
  static const String themeLight = 'Светлая';
  static const String themeDark = 'Тёмная';
  static const String themeColor = 'Цвет темы';
  static const String selectionColor = 'Выберите цвет';
  static const String close = 'Закрыть';

  static const String searchByChapters = 'Поиск по главам';
  static const String searchBySurahs = 'Поиск по сурам';
  static const String startSearch = 'Начните поиск';
  static const String searchAyahs = 'Поиск аятов';
  static const String strShort = 'Стр.';
  static const String minShort = 'Мин.';
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
  static const String vibration = 'Вибрация';
  static const String showCountLabel = 'Показать количество';
  static const String countReset = 'Счётчик сброшен';
  static const String undo = 'Отменить';
  static const String ready = 'Готово';
  static const String cancel = 'Отмена';
  static const String select = 'Выбрать';
  static const String monthlySchedule = 'Расписание на месяц';

  static const String selectionCity = 'Выбор города';
  static const String selectCity = 'Выбрать город';
  static const String enterQuery = 'Введите запрос';

  static String qiblahDirectionDescription(String qiblahDirection) => 'Кибла на $qiblahDirection\u00B0';

  static const List<String> weekDays = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  static const String notifications = 'Уведомления';
  static const String nearWhiteDays = 'Приближаются белые дни';
  static const String whiteDays = 'Белые дни';
  static const String prayers = 'Молитвы';
  static const String iqamahs = 'Икамы';
  static const String friday = 'Пятница';
  static const String fasting = 'Пост';
  static const String fastMonday = 'Пост в понедельник';
  static const String fastThursday = 'Пост в четверг';
  static const String tomorrowFriday = 'Завтра пятница';
  static const String lastFridayHour = 'Последний час пятницы';
  static const String tomorrowDesirableFastingDay = 'Завтра день желательного поста';
  static const String desirableFastingDay = 'День желательного поста';
  static const String remind = 'Напоминание';

  static const String prayerTime = 'Время молитвы';
  static const String prayerFajr = 'Фаджр';
  static const String prayerDhuhr = 'Зухр';
  static const String prayerAsr = '\'Аср';
  static const String prayerMaghrib = 'Магриб';
  static const String prayerIsha = '\'Иша';
  static const String sunriseDuha = 'Восход (Духа)';

  static const String sunrise = 'Восход';
  static const String midnight = 'Полночь';
  static const String lastThirdNight = '1/3 ночи';

  static const String daysToRamadan = 'Дней до Рамадана';
  static const String holyRamadan = 'Священный Рамадан';

  static const String loadData = 'Загрузка данных';
  static const String errorLoad = 'Ошибка загрузки';

  static const String morning = 'Утром';
  static const String evening = 'Вечером';
  static const String beforeSleep = 'Перед сном';
  static const String afterPrayer = 'После молитвы';
  static const String istikhara = 'Истихара';

  static const String copied = 'Скопировано';

  static const String selectedCity = 'Выбранный город';
  static const String prayerMethodCalculate = 'Методы расчёта времени молитв';
  static const String highLatitude = 'Высокие широты';
  static const String correctionMinutes = 'Корректировка минут';
  static const String asrMethod = 'Молитва \'аср';
  static const String winterTime = 'Зимнее время';
  static const String dstMode = 'Зимнее время (DST)';
  static const String labelDefault = 'По умолчанию';

  static const String defCity = 'Mecca';
  static const String defCountry = 'Saudi Arabia';
  static const double defLatitude = 21.42580;
  static const double defLongitude = 39.82410;

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

  static const holidayRamadanStart = 'Начало Рамадана';
  static const holidayEidAlFitr = '\'Ид аль-Фитр';
  static const holidayDhulhijjahStart = 'Начало Зуль-хиджи';
  static const holidayArafah = 'День \'Арафа';
  static const holidayEidAlAdha = '\'Ид аль-Адха';
  static const holidayAshura = 'День \'Ашура';
  static const today = 'Сегодня';
  static const daysShort = 'дн.';

  static const List<String> prayerCalculationNamesList = [
    'Russia',
    'Tatarstan',
    'Dagestan',
    'Chechnya',
    'North America (ISNA)',
    'Muslim world league (MWL)',
    'Umm al-Qura',
    'France',
    'Dubai',
    'Egyptian',
    'Karachi',
    'Kuwait',
    'Moon sighting committee (MSC)',
    'Qatar',
    'Turkey',
    'Singapore',
  ];

  static const List<String> highLatitudeNamesList = [
    'Middle of the night',
    'Seventh of the night',
    'Twilight angle',
  ];

  static const List<String> asrMethodNamesList = [
    'Shafi',
    'Hanafi',
  ];

  static const List<String> gregorianMonthsList = <String>[
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

  static const List<String> hijriMonthsList = <String>[
    'мухаррам',
    'сафар',
    'раби аль-авваль',
    'раби ас-сани',
    'джумада аль-уля',
    'джумада ас-сания',
    'раджаб',
    'ша’абан',
    'рамадан',
    'шавваль',
    'зуль-ка’ада',
    'зуль-хиджа',
  ];

  static const String adhkarDuringAdhan = 'Слова поминания во время азана';
  static const String adhkarAfterPrayer = 'Слова поминания после молитвы';
  static const String adhkarMorning = 'Время утренних азкаров';
  static const String adhkarEvening = 'Время вечерних азкаров';
  static const String adhkarNight = 'Время ночных азкаров';

  static const List<String> tasbeehCountsList = [
    '--/--',
    '33',
    '100',
    '1000',
  ];

  static String searchByQuery(String query, String matches) => 'По запросу «$query»\n$matches';

  static String searchError(String error) => 'Ошибка поиска: $error';
}
