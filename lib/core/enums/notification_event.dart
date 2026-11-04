import 'package:promus/core/constants/app_strings.dart';

enum NotificationEvent {
  fastMonday(AppStrings.fastMonday),
  fastThursday(AppStrings.fastThursday),
  fastWhiteDays(AppStrings.whiteDays),
  friday(AppStrings.friday),
  fridayLastHour(AppStrings.lastFridayHour);

  const NotificationEvent(this.label);

  final String label;
}
