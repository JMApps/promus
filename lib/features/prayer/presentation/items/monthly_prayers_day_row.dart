import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MonthlyPrayersDayRow extends StatelessWidget {
  const MonthlyPrayersDayRow({
    super.key,
    required this.day,
    required this.isToday,
    required this.isFriday,
    required this.values,
  });

  final int day;
  final bool isToday;
  final bool isFriday;
  final List<String> values;

  static const double height = 50;

  static const double leadingWidth = AppSpacing.medium * 2 + AppSpacing.medium;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontFeatures: const [.tabularFigures()],
      fontWeight: isToday ? .w600 : .w400,
      color: isToday ? scheme.onPrimaryContainer : (isFriday ? scheme.error : null),
    );

    return Container(
      height: height,
      color: isToday ? scheme.primaryContainer : null,
      padding: AppPaddings.hrSmallVrMedium,
      child: Row(
        children: [
          Padding(
            padding: AppPaddings.rightMedium,
            child: CircleAvatar(
              radius: AppSpacing.medium,
              backgroundColor: isToday ? scheme.surface : scheme.secondaryContainer,
              child: Text(
                day.toString(),
                style: AppTextStyles.small,
                textAlign: .start,
              ),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                style: style,
                textAlign: .center,
              ),
            ),
        ],
      ),
    );
  }
}
