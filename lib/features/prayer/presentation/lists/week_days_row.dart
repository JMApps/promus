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
    final weekDay = context.select<TimeState, int>((s) => s.getDateTime.weekday);
    return SizedBox(
      height: 35,
      child: Row(
        spacing: AppSpacing.small,
        children: [
          for (var day = DateTime.monday; day <= DateTime.sunday; day++)
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.small,
                  side: BorderSide(
                    width: day == weekDay ? 1.25 : 0.01,
                    color: appColors.primary,
                  ),
                ),
                child: Padding(
                  padding: AppPaddings.hrMediumVrXSmall,
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
      ),
    );
  }
}
