import 'package:flutter/material.dart';
import 'package:promus/core/constants/app_strings.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../state/prayer_state.dart';

class QiblaDirection extends StatelessWidget {
  const QiblaDirection({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerState = context.read<PrayerState>();
    final appColors = Theme.of(context).colorScheme;
    return Container(
      padding: AppPaddings.withoutTopMedium,
      alignment: .center,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            '${prayerState.country}, ${prayerState.city}',
            style: AppTextStyles.medium.copyWith(
              color: appColors.primary,
            ),
            textAlign: .center,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            AppStrings.qiblahDirectionDescription(
              prayerState.qiblahDirection.direction.toStringAsFixed(1),
            ),
            style: AppTextStyles.medium.copyWith(
              color: appColors.secondary,
            ),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
