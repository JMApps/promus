import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_text_styles.dart';

class HolidayItem extends StatelessWidget {
  const HolidayItem({
    super.key,
    required this.index,
    required this.title,
    required this.date,
    required this.daysLeft,
  });

  final int index;
  final String title;
  final DateTime date;
  final int daysLeft;

  static final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      shape: AppShapes.medium,
      visualDensity: .compact,
      leading: CircleAvatar(
        backgroundColor: appColors.inversePrimary,
        child: Text('${index + 1}'),
      ),
      title: Text(
        title,
        style: AppTextStyles.medium,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      subtitle: Text(_dateFormat.format(date)),
      trailing: Text(
        daysLeft == 0 ? AppStrings.today : '-$daysLeft ${AppStrings.daysShort}',
        style: textTheme.titleMedium?.copyWith(
          color: appColors.primary,
          fontWeight: .bold,
        ),
      ),
    );
  }
}
