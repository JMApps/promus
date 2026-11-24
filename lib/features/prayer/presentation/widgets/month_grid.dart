import 'package:material_ui/material_ui.dart';
import 'package:promus/core/theme/app_text_styles.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';

/// Сетка одного месяца, только для просмотра. Неделя с понедельника,
/// пятница выделена, сегодня обведено, прошедшие дни приглушены.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.title,
    required this.leadingDays,
    required this.daysInMonth,
    required this.today,
  });

  /// Название месяца и год.
  final String title;

  /// Сколько пустых клеток перед 1-м числом (Пн = 0 … Вс = 6).
  final int leadingDays;

  final int daysInMonth;

  /// Сегодняшнее число в этом месяце.
  final int today;

  /// Колонка пятницы при неделе с понедельника.
  static const int _fridayColumn = DateTime.friday - 1;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: appColors.surfaceContainerLow,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              title.toUpperCase(),
              style: AppTextStyles.medium.copyWith(color: appColors.primary),
            ),
            GridView.count(
              childAspectRatio: 1.15,
              crossAxisCount: AppSpacing.small.toInt(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final (i, name) in AppStrings.weekDays.indexed)
                  Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: i == _fridayColumn ? appColors.primary : appColors.onSurfaceVariant,
                        fontSize: AppSpacing.medium * 1.15,
                      ),
                    ),
                  ),
                for (var i = 0; i < leadingDays; i++) const SizedBox.shrink(),
                for (var day = 1; day <= daysInMonth; day++)
                  Center(
                    child: Container(
                      width: AppSpacing.medium * 2.75,
                      height: AppSpacing.medium * 2.75,
                      alignment: .center,
                      decoration: day == today ? BoxDecoration(
                        shape: .circle,
                        border: .all(
                          color: appColors.primary,
                          width: 1.5,
                        ),
                      ) : null,
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: AppSpacing.medium,
                          fontWeight: day == today || (leadingDays + day - 1) % 7 == _fridayColumn ? .bold : .normal,
                          color: switch (day) {
                            _ when day == today => appColors.primary,
                            _ when day < today => appColors.onSurface.withAlpha(100),
                            _ when (leadingDays + day - 1) % 7 == _fridayColumn =>
                              appColors.primary,
                            _ => appColors.onSurface,
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
