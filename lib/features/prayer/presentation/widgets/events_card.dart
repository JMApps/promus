import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import 'event_progress_ring.dart';
import 'event_times_stepper.dart';

class EventsCard extends StatelessWidget {
  const EventsCard({super.key});

  /// Минимальная ширина, при которой степпер и кольцо помещаются в ряд.
  static const double rowBreakpoint = 380;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Card(
      child: Padding(
        padding: AppPaddings.mediumBottomSmall,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < rowBreakpoint * textScale;
            return isCompact
                ? const Column(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              children: [
                EventProgressRing(size: 72),
                SizedBox(height: AppSpacing.small),
                EventTimesStepper(),
              ],
            )
                : const Row(
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              children: [
                Flexible(
                  child: EventTimesStepper(),
                ),
                SizedBox(width: AppSpacing.medium),
                EventProgressRing(),
              ],
            );
          },
        ),
      ),
    );
  }
}