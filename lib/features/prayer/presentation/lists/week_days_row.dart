import 'package:flutter/material.dart';
import 'package:promus/core/theme/app_radius.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';

class WeekDaysRow extends StatelessWidget {
  const WeekDaysRow({
    super.key,
    required this.weekDay,
  });

  final int weekDay;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          for (var day = DateTime.monday; day <= DateTime.sunday; day++)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.small,
                side: BorderSide(
                  width: day == weekDay ? 2.0 : 0.01,
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
                ),
              ),
            ),
        ],
      ),
    );
  }
}
