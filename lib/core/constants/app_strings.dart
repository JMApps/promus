import 'package:intl/intl.dart';

class AppStrings {
  AppStrings._();

  static const String appName = 'ПроМус';
  static const String appVersion = '1.0.0';
  static const String licenses = 'Лицензии';
  static const String pro = 'Про';
  static const String mus = 'Мус';

  static const String titleHome = 'Главная';
  static const String titleMushaf = 'Мусхаф';
  static const String titleFortress = 'Крепость';
  static const String titleCounter = 'Счётчик';

  static const String settings = 'Настройки';
  static const String params = 'Параметры';

  static const String timeModeLabel = 'Формат времени';
  static const String system = 'Системный';
  static const String timeMode12 = '12 часовой';
  static const String timeMode24 = '24 часовой';

  static const String alwaysOnDisplay = 'Дисплей всегда включён';
  static const String theme = 'Тема';
  static const String themeSystem = 'Системная';
  static const String themeLight = 'Светлая';
  static const String themeDark = 'Тёмная';
  static const String themeColor = 'Цвет темы';
  static const String selectionColor = 'Выберите цвет';
  static const String close = 'Закрыть';

  static const String searchByChapters = 'Поиск по главам';
  static const String startSearch = 'Начните поиск';
  static const String searchAyahs = 'Поиск аятов';
  static const String strShort = 'Стр.';
  static const String minShort = 'Мин.';
  static const String medina = 'Медина';
  static const String mecca = 'Мекка';
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
  static const String enterQueryLat = 'Введите запрос латиницей';

  static String qiblahDirectionDescription(String qiblahDirection) => 'Кибла — $qiblahDirection\u00B0 от севера';
  
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
  static const String ayahFridayAr = 'إِنَّ ٱللَّهَ وَمَلَٰٓئِكَتَهُۥ يُصَلُّونَ عَلَى ٱلنَّبِيِّۚ يَٰٓأَيُّهَا ٱلَّذِينَ ءَامَنُواْ صَلُّواْ عَلَيۡهِ وَسَلِّمُواْ تَسۡلِيمًا.';
  static const String ayahFridayRu = 'Воистину, Аллах и Его ангелы благословляют Пророка. О те, которые уверовали! Благословляйте его и приветствуйте миром';
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
  static const String winterTime = 'Зимнее/Летнее время';
  static const String minusHour = '– 1';
  static const String plusHour = '+ 1';
  static const String labelDefault = 'По умолчанию';

  static const String databasePreparing = 'Подготовка базы данных…';
  static const String databaseFailed = 'Не удалось подготовить базу данных';
  static const String databaseRetry = 'Попробовать заново';

  static const String allNotifications = 'Все уведомления';
  static const String iqamah = 'Икама';
  static const String prayerDuha = 'Ад-Духа';
  static const String adhkar = 'Азкары';
  static const String fridayEve = 'Накануне пятницы';
  static const String adhkarBeforeSleepReminder = 'Не забудь азкары перед сном!';
  static const String tomorrowWhiteDays = 'Завтра начинаются белые дни: 13-14-15';
  static const String notificationsEndingSoon = 'Уведомления скоро закончатся';
  static const String openAppToExtendNotifications = 'Откройте приложение, чтобы перепланировались уведомления для молитв.';

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

  static const holidayRamadanStart = 'Начало Рамадана';
  static const holidayEidAlFitr = '\'Ид аль-Фитр';
  static const holidayDhulhijjahStart = 'Начало Зуль-хиджи';
  static const holidayArafah = 'День \'Арафа';
  static const holidayEidAlAdha = '\'Ид аль-Адха';
  static const holidayAshura = 'День \'Ашура';
  static const today = 'Сегодня';
  static const daysShort = 'дн.';
  static const String hijriOffset = 'Сдвиг даты по хиджре';
  static const String share = 'Поделиться';
  static const String copy = 'Скопировать';

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
    'шаабан',
    'рамадан',
    'шавваль',
    'зуль-каада',
    'зуль-хиджжа',
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

  static String databaseOfCount(int index, int count) => 'База $index из $count. ';

  static String databaseCopying(int percent) => 'Копирование: $percent %';
}
