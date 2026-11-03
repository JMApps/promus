import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';

class HijriDatePicker extends StatelessWidget {
  const HijriDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Padding(
        padding: AppPaddings.hrMedium,
        child: SfHijriDateRangePicker(
          headerHeight: 0,
          headerStyle: DateRangePickerHeaderStyle(
            textAlign: .center,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: .w600,
              color: appColors.onSurface,
            ),
          ),
          todayHighlightColor: Colors.transparent,
          enablePastDates: false,
          view: .month,
          backgroundColor: appColors.surfaceContainerLow,
          allowViewNavigation: false,
          showTodayButton: false,
          showNavigationArrow: false,
          monthViewSettings: const HijriDatePickerMonthViewSettings(
            firstDayOfWeek: 1,
            weekendDays: <int>[5],
          ),
          monthCellStyle: HijriDatePickerMonthCellStyle(
            todayCellDecoration: BoxDecoration(
              shape: .circle,
              color: Colors.transparent,
              border: .all(color: appColors.tertiary, width: 1.5),
            ),
            todayTextStyle: TextStyle(
              color: appColors.tertiary,
              fontSize: AppSpacing.medium,
              fontWeight: .bold,
            ),
            weekendTextStyle: TextStyle(
              color: appColors.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
