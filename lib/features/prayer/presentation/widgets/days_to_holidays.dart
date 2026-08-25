import 'package:flutter/material.dart';

import '../../../../core/theme/app_shapes.dart';

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
    return ListTile(
      tileColor: appColors.primaryContainer,
      shape: AppShapes.medium,
      title: Text(eventDay),
    );
  }
}
