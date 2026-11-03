import 'app_strings.dart';

typedef HijriHoliday = ({String title, int month, int day});

const hijriHolidays = <HijriHoliday>[
  (title: AppStrings.holidayRamadanStart, month: 9, day: 1),
  (title: AppStrings.holidayEidAlFitr, month: 10, day: 1),
  (title: AppStrings.holidayDhulhijjahStart, month: 12, day: 1),
  (title: AppStrings.holidayArafah, month: 12, day: 9),
  (title: AppStrings.holidayEidAlAdha, month: 12, day: 10),
  (title: AppStrings.holidayAshura, month: 1, day: 10),
];