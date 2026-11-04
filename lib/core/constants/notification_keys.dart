import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

abstract final class NotificationKeys {
  static const String keyMainNotificationsBox = 'key_main_notifications_box';

  static const String prayerChannelId = 'Prayer notifications';
  static const String reminderChannelId = 'When prayer daily notifications';

  static const String defaultPrayerChannelName = 'Время молитвы';
  static const String defaultPrayerChannelDescription = 'Уведомления о наступлении времени молитвы';
  static const String defaultReminderChannelName = 'Напоминания';
  static const String defaultReminderChannelDescription = 'Напоминания о посте, пятнице и белых днях';

  static const String keyFajrNotification = 'key_fajr_notification';
  static const String keySunriseNotification = 'key_sunrise_notification';
  static const String keyDhuhrNotification = 'key_dhuhr_notification';
  static const String keyAsrNotification = 'key_asr_notification';
  static const String keyMaghribNotification = 'key_maghrib_notification';
  static const String keyIshaNotification = 'key_isha_notification';

  static const String keyFajrIkamah = 'key_fajr_ikamah';
  static const String keyDhuhrIkamah = 'key_dhuhr_ikamah';
  static const String keyAsrIkamah = 'key_asr_ikamah';
  static const String keyMaghribIkamah = 'key_maghrib_ikamah';
  static const String keyIshaIkamah = 'key_isha_ikamah';

  static const String keyFajrIkamahValue = 'key_fajr_ikamah_value';
  static const String keyDhuhrIkamahValue = 'key_dhuhr_ikamah_value';
  static const String keyAsrIkamahValue = 'key_asr_ikamah_value';
  static const String keyMaghribIkamahValue = 'key_maghrib_ikamah_value';
  static const String keyIshaIkamahValue = 'key_isha_ikamah_value';

  static const String keyFastMondayNotification = 'key_fast_monday_notification';
  static const String keyFastThursdayNotification = 'key_fast_thursday_notification';
  static const String keyFastWhiteDaysNotification = 'key_fast_white_days_notification';

  static const String keyFridayNotification = 'key_friday_notification';
  static const String keyLastHourFridayNotification = 'key_last_hour_friday_notification';

  static Iterable<String> get allNotificationDefValues => [
    ...prayer.values,
    ...ikamahEnabled.values,
    ...ikamahMinutes.values,
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

  static const ikamahEnabled = <PrayerLabels, String>{
    PrayerLabels.fajr: keyFajrIkamah,
    PrayerLabels.dhuhr: keyDhuhrIkamah,
    PrayerLabels.asr: keyAsrIkamah,
    PrayerLabels.maghrib: keyMaghribIkamah,
    PrayerLabels.isha: keyIshaIkamah,
  };

  static const ikamahMinutes = <PrayerLabels, String>{
    PrayerLabels.fajr: keyFajrIkamahValue,
    PrayerLabels.dhuhr: keyDhuhrIkamahValue,
    PrayerLabels.asr: keyAsrIkamahValue,
    PrayerLabels.maghrib: keyMaghribIkamahValue,
    PrayerLabels.isha: keyIshaIkamahValue,
  };

  static const event = <NotificationEvent, String>{
    NotificationEvent.fastMonday: keyFastMondayNotification,
    NotificationEvent.fastThursday: keyFastThursdayNotification,
    NotificationEvent.fastWhiteDays: keyFastWhiteDaysNotification,
    NotificationEvent.friday: keyFridayNotification,
    NotificationEvent.fridayLastHour: keyLastHourFridayNotification,
  };
}