import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

abstract final class NotificationKeys {
  static const String appIconName = 'app_icon_notification';

  static const String keyMainNotificationsBox = 'key_main_notifications_box';
  static const String keyPermissionAsked = 'key_permission_asked';

  static const String prayerChannelId = 'Prayer notifications';
  static const String iqamahChannelId = 'iqamah_notifications';
  static const String reminderChannelId = 'When prayer daily notifications';

  static const String defaultPrayerChannelName = 'Время молитвы';
  static const String defaultPrayerChannelDescription = 'Уведомления о наступлении времени молитвы';
  static const String defaultIqamahChannelName = 'Икама';
  static const String defaultIqamahChannelDescription = 'Уведомления о времени икамы';
  static const String defaultReminderChannelName = 'Напоминания';
  static const String defaultReminderChannelDescription = 'Напоминания о посте, пятнице и белых днях';

  static const List<int> legacyIds = [
    435, 123, 675, 342, 768, 245, // намазы
    875, 579, 900, 656, 906, // икамы
    350, 425, 656, // посты
    223, 321, // пятница
  ];

  static const String keyFajrNotification = 'key_fajr_notification';
  static const String keySunriseNotification = 'key_sunrise_notification';
  static const String keyDhuhrNotification = 'key_dhuhr_notification';
  static const String keyAsrNotification = 'key_asr_notification';
  static const String keyMaghribNotification = 'key_maghrib_notification';
  static const String keyIshaNotification = 'key_isha_notification';

  static const String keyFajrIqamah = 'key_fajr_iqamah';
  static const String keyDhuhrIqamah = 'key_dhuhr_iqamah';
  static const String keyAsrIqamah = 'key_asr_iqamah';
  static const String keyMaghribIqamah = 'key_maghrib_iqamah';
  static const String keyIshaIqamah = 'key_isha_iqamah';

  static const String keyFajrIqamahValue = 'key_fajr_iqamah_value';
  static const String keyDhuhrIqamahValue = 'key_dhuhr_iqamah_value';
  static const String keyAsrIqamahValue = 'key_asr_iqamah_value';
  static const String keyMaghribIqamahValue = 'key_maghrib_iqamah_value';
  static const String keyIshaIqamahValue = 'key_isha_iqamah_value';

  static const String keyFastMondayNotification = 'key_fast_monday_notification';
  static const String keyFastThursdayNotification = 'key_fast_thursday_notification';
  static const String keyFastWhiteDaysNotification = 'key_fast_white_days_notification';

  static const String keyFridayNotification = 'key_friday_notification';
  static const String keyLastHourFridayNotification = 'key_last_hour_friday_notification';

  static Iterable<String> get allNotificationDefValues => [
    ...prayer.values,
    ...iqamahEnabled.values,
    ...iqamahMinutes.values,
    ...event.values,
  ];

  static const prayer = <PrayerLabels, String>{
    PrayerLabels.fajr: keyFajrNotification,
    PrayerLabels.sunrise: keySunriseNotification,
    PrayerLabels.dhuhr: keyDhuhrNotification,
    PrayerLabels.asr: keyAsrNotification,
    PrayerLabels.maghrib: keyMaghribNotification,
    PrayerLabels.isha: keyIshaNotification,
  };

  static const iqamahEnabled = <PrayerLabels, String>{
    PrayerLabels.fajr: keyFajrIqamah,
    PrayerLabels.dhuhr: keyDhuhrIqamah,
    PrayerLabels.asr: keyAsrIqamah,
    PrayerLabels.maghrib: keyMaghribIqamah,
    PrayerLabels.isha: keyIshaIqamah,
  };

  static const iqamahMinutes = <PrayerLabels, String>{
    PrayerLabels.fajr: keyFajrIqamahValue,
    PrayerLabels.dhuhr: keyDhuhrIqamahValue,
    PrayerLabels.asr: keyAsrIqamahValue,
    PrayerLabels.maghrib: keyMaghribIqamahValue,
    PrayerLabels.isha: keyIshaIqamahValue,
  };

  static const event = <NotificationEvent, String>{
    NotificationEvent.fastMonday: keyFastMondayNotification,
    NotificationEvent.fastThursday: keyFastThursdayNotification,
    NotificationEvent.fastWhiteDays: keyFastWhiteDaysNotification,
    NotificationEvent.friday: keyFridayNotification,
    NotificationEvent.fridayLastHour: keyLastHourFridayNotification,
  };
}