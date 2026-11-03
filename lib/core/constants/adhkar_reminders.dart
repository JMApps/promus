import 'app_strings.dart';

typedef AdhkarReminder = ({String message, int chapterId});

const adhkarReminders = <AdhkarReminder>[
  (message: AppStrings.adhkarDuringAdhan, chapterId: 15),
  (message: AppStrings.adhkarAfterPrayer, chapterId: 25),
  (message: AppStrings.adhkarMorning, chapterId: 27),
  (message: AppStrings.adhkarEvening, chapterId: 28),
  (message: AppStrings.adhkarNight, chapterId: 29),
];