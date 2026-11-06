import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/prayer_state.dart';
import 'gregorian_date_picker.dart';
import 'main_date_card_item.dart';

class GregorianDateCard extends StatelessWidget {
  const GregorianDateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final gregorianDateText = context.select<PrayerState, String>(
      (s) => s.gregorianDateText,
    );
    return MainDateCardItem(
      dateText: gregorianDateText,
      itemColor: Theme.of(context).colorScheme.primary,
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => const GregorianDatePicker(),
      ),
    );
  }
}
