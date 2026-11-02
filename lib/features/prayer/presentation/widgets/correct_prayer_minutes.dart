import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import 'correction_minutes_sheet.dart';

class CorrectPrayerMinutes extends StatelessWidget {
  const CorrectPrayerMinutes({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: const Icon(Icons.exposure),
      tooltip: AppStrings.correctionMinutes,
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const CorrectionMinutesSheet(),
      ),
    );
  }
}
