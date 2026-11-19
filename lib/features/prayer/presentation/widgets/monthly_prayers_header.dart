import 'package:material_ui/material_ui.dart';

import '../../../../core/enums/prayer_labels.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../items/monthly_prayers_day_row.dart';

class MonthlyPrayersHeader extends StatelessWidget {
  const MonthlyPrayersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.small,
      child: Row(
        children: [
          const SizedBox(width: MonthlyPrayersDayRow.leadingWidth),
          for (final prayer in PrayerLabels.values)
            Expanded(
              child: FittedBox(
                fit: .scaleDown,
                child: Text(
                  prayer.label,
                  style: AppTextStyles.small.copyWith(fontSize: 14.0),
                  textAlign: .center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
