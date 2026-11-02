import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../state/prayer_state.dart';

class DstModeItem extends StatelessWidget {
  const DstModeItem({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final dst = context.select<PrayerState, bool>((p) => p.dst);
    return ListTile(
      onTap: () => context.read<PrayerState>().setDst = !dst,
      tileColor: appColors.secondaryContainer.withAlpha(dst ? 255 : 0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.5,
          color: appColors.primary,
        ),
        borderRadius: AppRadius.large,
      ),
      splashColor: appColors.secondaryContainer,
      visualDensity: VisualDensity.compact,
      contentPadding: AppPaddings.hrMedium,
      title: const Text(AppStrings.dstMode),
      trailing: Switch(
        value: dst,
        onChanged: (value) => context.read<PrayerState>().setDst = value,
      ),
    );
  }
}
