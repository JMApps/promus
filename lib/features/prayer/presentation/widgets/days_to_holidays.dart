import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';

class DaysToHolidays extends StatelessWidget {
  const DaysToHolidays({
    super.key,
    required this.eventDay,
    required this.remainingDays,
  });

  final String eventDay;
  final int remainingDays;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Ink(
      decoration: ShapeDecoration(
        shape: AppShapes.medium,
        gradient: LinearGradient(
          colors: [
            appColors.primaryContainer,
            appColors.tertiaryContainer,
            appColors.secondaryContainer,
          ],
        ),
      ),
      child: ListTile(
        onTap: () {},
        shape: AppShapes.medium,
        splashColor: appColors.secondaryContainer,
        visualDensity: .compact,
        contentPadding: AppPaddings.hrMedium,
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              eventDay,
              style: const TextStyle(
                overflow: .ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            const Text('100'),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 17.5,
        ),
      ),
    );
  }
}
