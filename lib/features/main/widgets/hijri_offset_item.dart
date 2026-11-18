import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_prayer_keys.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../prayer/state/prayer_state.dart';

class HijriOffsetItem extends StatelessWidget {
  const HijriOffsetItem({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final (offset, hijriDate) = context.select<PrayerState, (int, String)>(
      (s) => (s.hijriOffset, s.hijriDateText),
    );
    final isChanged = offset != 0;
    final offsetText = switch (offset) {
      > 0 => '+$offset',
      < 0 => '−${offset.abs()}',
      _ => '0',
    };

    return Padding(
      padding: AppPaddings.small,
      child: ListTile(
        tileColor: appColors.secondaryContainer.withAlpha(isChanged ? 255 : 0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 0.5,
              color: appColors.primary,
          ),
          borderRadius: AppRadius.large,
        ),
        visualDensity: .compact,
        contentPadding: AppPaddings.hrMedium,
        title: const Text(
          AppStrings.hijriOffset,
          style: AppTextStyles.medium,
        ),
        subtitle: Text(hijriDate),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: offset > AppPrayerKeys.minHijriOffset ? () => context.read<PrayerState>().setHijriOffset = offset - 1 : null,
              icon: const Icon(Icons.remove_circle_outline_rounded),
            ),
            SizedBox(
              width: AppSpacing.xLarge * 1.25,
              child: Text(
                offsetText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isChanged ? appColors.primary : appColors.onSurfaceVariant,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: offset < AppPrayerKeys.maxHijriOffset ? () => context.read<PrayerState>().setHijriOffset = offset + 1 : null,
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
