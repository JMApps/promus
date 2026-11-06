import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/hijri_holidays.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/time_state.dart';
import '../items/holiday_item.dart';

class HolidaysList extends StatelessWidget {
  const HolidaysList({super.key});

  @override
  Widget build(BuildContext context) {
    final time = context.watch<TimeState>();

    final items = [
      for (final h in hijriHolidays)
        (
          title: h.title,
          date: time.nextHijriDate(h.month, h.day),
          days: time.daysUntilHijri(h.month, h.day),
        ),
    ]..sort((a, b) => a.days.compareTo(b.days));

    return ListView.separated(
      padding: AppPaddings.withoutTopSmall,
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(
        indent: AppSpacing.medium,
        endIndent: AppSpacing.medium,
      ),
      itemBuilder: (_, i) => HolidayItem(
        index: i,
        title: items[i].title,
        date: items[i].date,
        daysLeft: items[i].days,
      ),
    );
  }
}
