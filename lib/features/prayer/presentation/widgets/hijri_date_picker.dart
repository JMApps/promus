import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../state/time_state.dart';
import 'month_grid.dart';

class HijriDatePicker extends StatelessWidget {
  const HijriDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final (title, leadingDays, daysInMonth, today) = context.select<TimeState, (String, int, int, int)>((s) {
      // Сегодня по хиджре — с пользовательским смещением.
      final h = s.getHijriDateTime;
      return (
      '${AppStrings.hijriMonthsList[h.hMonth - 1]} ${h.hYear}',
      // День недели 1-го числа: от сегодняшнего (Пн = 0) отступаем на (hDay − 1) дней.
      // В Dart % с положительным делителем всегда даёт 0…6, даже для отрицательного числа.
      (s.getDateTime.weekday - 1 - (h.hDay - 1)) % 7,
      h.lengthOfMonth,
      h.hDay,
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
