import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../other/widgets/main_gradient_text.dart';
import '../../state/prayer_state.dart';
import 'prayer_correct_tile.dart';

class CorrectionMinutesSheet extends StatelessWidget {
  const CorrectionMinutesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final times = context.select<PrayerState, PrayerTimes>((s) => s.prayerTimes);
    final adjustments = context.select<PrayerState, (int, int, int, int, int, int)>(
      (s) => (
        s.fajrAdjustment,
        s.sunriseAdjustment,
        s.dhuhrAdjustment,
        s.asrAdjustment,
        s.maghribAdjustment,
        s.ishaAdjustment,
      ),
    );
    final state = context.read<PrayerState>();

    final rows = <({String name, DateTime time, int minutes, ValueChanged<int> onChanged})>[
      (
        name: AppStrings.prayerFajr,
        time: times.fajr,
        minutes: adjustments.$1,
        onChanged: (v) => state.fajrAdjustment = v,
      ),
      (
        name: AppStrings.sunrise,
        time: times.sunrise,
        minutes: adjustments.$2,
        onChanged: (v) => state.sunriseAdjustment = v,
      ),
      (
        name: AppStrings.prayerDhuhr,
        time: times.dhuhr,
        minutes: adjustments.$3,
        onChanged: (v) => state.dhuhrAdjustment = v,
      ),
      (
        name: AppStrings.prayerAsr,
        time: times.asr,
        minutes: adjustments.$4,
        onChanged: (v) => state.asrAdjustment = v,
      ),
      (
        name: AppStrings.prayerMaghrib,
        time: times.maghrib,
        minutes: adjustments.$5,
        onChanged: (v) => state.maghribAdjustment = v,
      ),
      (
        name: AppStrings.prayerIsha,
        time: times.isha,
        minutes: adjustments.$6,
        onChanged: (v) => state.ishaAdjustment = v,
      ),
    ];

    return SingleChildScrollView(
      padding: AppPaddings.withoutTopMedium,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          const MainGradientText(text: AppStrings.correctionMinutes),
          const SizedBox(height: AppSpacing.medium),
          for (final r in rows)
            Card(
              margin: AppPaddings.bottomMedium,
              child: PrayerCorrectTile(
                label: '${r.name}\n${state.formatTime(r.time)}',
                minutes: r.minutes,
                decrementPressed: () => r.onChanged(r.minutes - 1),
                incrementPressed: () => r.onChanged(r.minutes + 1),
              ),
            ),
          const SizedBox(height: AppSpacing.small),
          OutlinedButton(
            onPressed: () {
              state.resetAdjustments();
            },
            child: const Text(
              AppStrings.labelDefault,
              style: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
