import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/time_state.dart';

class WeekDaysRow extends StatelessWidget {
  const WeekDaysRow({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final weekDay = context.select<TimeState, int>(
      (s) => s.getDateTime.weekday,
    );
    return Row(
      spacing: AppSpacing.small,
      children: [
        for (var day = 1; day <= 7; day++)
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.small,
                side: day == weekDay ? BorderSide(width: 1.5, color: appColors.primary) : .none,
              ),
              child: Padding(
                padding: AppPaddings.small,
                child: Text(
                  AppStrings.weekDays[day - 1],
                  style: TextStyle(
                    color: appColors.primary,
                  ),
                  textAlign: .center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
