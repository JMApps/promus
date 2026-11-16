import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/time_format_mode.dart';
import '../../state/prayer_state.dart';

class TimeFormatModeSegment extends StatelessWidget {
  const TimeFormatModeSegment({super.key});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimeFormatMode>(
      segments: const [
        ButtonSegment(
          value: TimeFormatMode.system,
          label: Text(AppStrings.system),
        ),
        ButtonSegment(
          value: TimeFormatMode.h24,
          label: Text(AppStrings.timeMode24),
        ),
        ButtonSegment(
          value: TimeFormatMode.h12,
          label: Text(AppStrings.timeMode12),
        ),
      ],
      selected: {context.select((PrayerState s) => s.timeFormatMode)},
      onSelectionChanged: (selection) => context.read<PrayerState>().setTimeFormatMode = selection.first,
    );
  }
}
