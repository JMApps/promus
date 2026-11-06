import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import 'event_progress_ring.dart';
import 'event_times_stepper.dart';

class EventsCard extends StatelessWidget {
  const EventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: AppPaddings.mediumBottomSmall,
        child: Row(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          children: [
            Flexible(
              child: EventTimesStepper(),
            ),
            SizedBox(width: AppSpacing.large),
            EventProgressRing(),
          ],
        ),
      ),
    );
  }
}
