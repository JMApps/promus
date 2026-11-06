import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/prayer_state.dart';
import 'hijri_date_picker.dart';
import 'main_date_card_item.dart';

class HijriDateCard extends StatelessWidget {
  const HijriDateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriDateText = context.select<PrayerState, String>(
      (s) => s.hijriDateText,
    );
    return MainDateCardItem(
      dateText: hijriDateText,
      itemColor: Theme.of(context).colorScheme.tertiary,
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => const HijriDatePicker(),
      ),
    );
  }
}
