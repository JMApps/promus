import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../state/time_state.dart';
import 'month_grid.dart';

class GregorianDatePicker extends StatelessWidget {
  const GregorianDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final (title, leadingDays, daysInMonth, today) = context.select<TimeState, (String, int, int, int)>((s) {
      final d = s.getDateTime;
      return (
      DateFormat('LLLL y', 'ru').format(d),
      DateTime(d.year, d.month).weekday - 1,
      DateUtils.getDaysInMonth(d.year, d.month),
      d.day,
      );
    });

    return MonthGrid(
      title: title,
      leadingDays: leadingDays,
      daysInMonth: daysInMonth,
      today: today,
    );
  }
}
