import '../constants/app_strings.dart';
import '../enums/notification_event.dart';
import '../enums/prayer_labels.dart';

/// Тексты уведомлений. Сами строки живут в AppStrings, здесь — только
/// какая строка к какому уведомлению. Вшиваются в момент планирования,
/// поэтому смена языка (если появится локализация) должна вызывать синхронизацию.
abstract final class NotificationTexts {
  static const String prayerTitle = AppStrings.prayerTime;
  static const String iqamahTitle = AppStrings.iqamah;
  static const String reminderTitle = AppStrings.remind;

  static const String openAppTitle = AppStrings.notificationsEndingSoon;
  static const String openAppBody = AppStrings.openAppToExtendNotifications;

  /// «Время молитвы» → «Фаджр».
  static const prayerBodies = <PrayerLabels, String>{
    PrayerLabels.fajr: AppStrings.prayerFajr,
    PrayerLabels.dhuhr: AppStrings.prayerDhuhr,
    PrayerLabels.asr: AppStrings.prayerAsr,
    PrayerLabels.maghrib: AppStrings.prayerMaghrib,
    PrayerLabels.isha: AppStrings.prayerIsha,
  };

  /// «Икама» → «Время молитвы Фаджр».
  static const iqamahBodies = <PrayerLabels, String>{
    PrayerLabels.fajr: '${AppStrings.prayerTime} ${AppStrings.prayerFajr}',
    PrayerLabels.dhuhr: '${AppStrings.prayerTime} ${AppStrings.prayerDhuhr}',
    PrayerLabels.asr: '${AppStrings.prayerTime} ${AppStrings.prayerAsr}',
    PrayerLabels.maghrib: '${AppStrings.prayerTime} ${AppStrings.prayerMaghrib}',
    PrayerLabels.isha: '${AppStrings.prayerTime} ${AppStrings.prayerIsha}',
  };

  /// Ад-Духа приходит как молитва, остальное — как «Напоминание».
  static const eventTitles = <NotificationEvent, String>{
    NotificationEvent.duha: prayerTitle,
    NotificationEvent.morningAdhkar: reminderTitle,
    NotificationEvent.eveningAdhkar: reminderTitle,
    NotificationEvent.sleepAdhkar: reminderTitle,
    NotificationEvent.fridayEve: reminderTitle,
    NotificationEvent.fridayLastHour: reminderTitle,
    NotificationEvent.fastMonday: reminderTitle,
    NotificationEvent.fastThursday: reminderTitle,
    NotificationEvent.fastWhiteDays: reminderTitle,
  };

  static const eventBodies = <NotificationEvent, String>{
    NotificationEvent.duha: AppStrings.prayerDuha,
    NotificationEvent.morningAdhkar: AppStrings.adhkarMorning,
    NotificationEvent.eveningAdhkar: AppStrings.adhkarEvening,
    NotificationEvent.sleepAdhkar: AppStrings.adhkarBeforeSleepReminder,
    NotificationEvent.fridayEve: AppStrings.tomorrowFriday,
    NotificationEvent.fridayLastHour: AppStrings.lastFridayHour,
    NotificationEvent.fastMonday: AppStrings.tomorrowDesirableFastingDay,
    NotificationEvent.fastThursday: AppStrings.tomorrowDesirableFastingDay,
    NotificationEvent.fastWhiteDays: AppStrings.tomorrowWhiteDays,
  };
}
