import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/sleek_entity.dart';
import '../../state/prayer_state.dart';
import 'elapsed_prayer_time_sleek.dart';
import 'remaining_prayer_time_sleek.dart';

class PrayerProgressRings extends StatelessWidget {
  const PrayerProgressRings({super.key});

  @override
  Widget build(BuildContext context) {
    final (elapsed, remaining) = context.select<PrayerState, (SleekEntity, SleekEntity)>(
      (s) => (s.elapsed, s.remaining),
    );
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        ElapsedPrayerTimeSleek(
          prayerName: elapsed.name,
          progress: elapsed.progress,
          timeText: elapsed.timeText,
        ),
        const SizedBox(height: AppSpacing.medium),
        RemainingPrayerTimeSleek(
          prayerName: remaining.name,
          progress: remaining.progress,
          timeText: remaining.timeText,
        ),
      ],
    );
  }
}
