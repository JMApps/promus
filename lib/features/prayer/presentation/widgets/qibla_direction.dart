import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../state/prayer_state.dart';

class QiblaDirection extends StatelessWidget {
  const QiblaDirection({super.key});

  @override
  Widget build(BuildContext context) {
    // Строки сравниваются по значению: перестройка только при смене города
    // или направления, а не на каждое уведомление PrayerState.
    final (:country, :city, :direction) = context.select<PrayerState, ({String country, String city, String direction})>((s) => (
      country: s.country,
      city: s.city,
      direction: s.qiblahDirection.direction.toStringAsFixed(1),
      ),
    );
    final appColors = Theme.of(context).colorScheme;
    return Container(
      padding: AppPaddings.withoutTopMedium,
      alignment: .center,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            '$country, $city',
            style: AppTextStyles.medium.copyWith(
              color: appColors.primary,
            ),
            textAlign: .center,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            AppStrings.qiblahDirectionDescription(direction),
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