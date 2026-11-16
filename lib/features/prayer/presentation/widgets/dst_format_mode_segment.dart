import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/dst_format_mode.dart';
import '../../state/prayer_state.dart';

class DSTFormatModeSegment extends StatelessWidget {
  const DSTFormatModeSegment({super.key});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DSTFormatMode>(
      segments: const [
        ButtonSegment(
          value: DSTFormatMode.minusHour,
          label: Text(AppStrings.minusHour),
        ),
        ButtonSegment(
          value: DSTFormatMode.system,
          label: Text(AppStrings.system),
        ),
        ButtonSegment(
          value: DSTFormatMode.plusHour,
          label: Text(AppStrings.plusHour),
        ),
      ],
      selected: {context.select((PrayerState s) => s.dstMode)},
      onSelectionChanged: (selection) => context.read<PrayerState>().setDstMode = selection.first,
    );
  }
}