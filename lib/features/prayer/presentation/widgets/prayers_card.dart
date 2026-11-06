import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import 'prayer_progress_rings.dart';
import 'prayer_times_stepper.dart';

class PrayersCard extends StatelessWidget {
  const PrayersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: AppPaddings.medium,
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Flexible(
              child: PrayerTimesStepper(),
            ),
            Flexible(
              flex: 2,
              child: PrayerProgressRings(),
            ),
          ],
        ),
      ),
    );
  }
}
