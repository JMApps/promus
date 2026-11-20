import '../constants/app_strings.dart';

/// Уведомления помимо пяти намазов и икам. [label] — подпись переключателя
/// в настройках; тексты самих уведомлений — в NotificationTexts.
enum NotificationEvent {
  duha(AppStrings.prayerDuha),
  morningAdhkar(AppStrings.morning),
  eveningAdhkar(AppStrings.evening),
  sleepAdhkar(AppStrings.beforeSleep),
  fridayEve(AppStrings.fridayEve),
  fridayLastHour(AppStrings.lastFridayHour),
  fastMonday(AppStrings.fastMonday),
  fastThursday(AppStrings.fastThursday),
  fastWhiteDays(AppStrings.whiteDays);

  const NotificationEvent(this.label);

  final String label;
}
