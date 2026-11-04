import 'package:flutter/material.dart';

import '../../../../core/enums/prayer_labels.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_text_styles.dart';

class MonthlyPrayersHeader extends StatelessWidget {
  const MonthlyPrayersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.small,
      child: Row(
        children: [
          const SizedBox(
            width: 37.5,
            height: 37.5,
          ),
          for (final prayer in PrayerLabels.values)
            Expanded(
              child: FittedBox(
                fit: .scaleDown,
                child: Text(
                  prayer.label,
                  style: AppTextStyles.small,
                  textAlign: .center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
