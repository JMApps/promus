import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/prayer_state.dart';
import '../../state/time_state.dart';
import '../items/monthly_prayers_day_row.dart';

class MonthlyPrayersList extends StatefulWidget {
  const MonthlyPrayersList({super.key});

  @override
  State<MonthlyPrayersList> createState() => _MonthlyPrayersListState();
}

class _MonthlyPrayersListState extends State<MonthlyPrayersList> {
  static const double _dividerHeight = 1;
  static const double _rowExtent = MonthlyPrayersDayRow.height + _dividerHeight;

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    final today = context.read<TimeState>().getDateTime;

    _controller = ScrollController(
      initialScrollOffset: (today.day - 1) * _rowExtent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PrayerState>();
    final now = context.watch<TimeState>().getDateTime;
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    return Scrollbar(
      controller: _controller,
      child: ListView.separated(
        controller: _controller,
        itemCount: daysInMonth,
        separatorBuilder: (context, index) => const Divider(height: _dividerHeight),
        itemBuilder: (context, index) {
          final date = DateTime(now.year, now.month, index + 1);
          final times = state.prayerTimeSchedule(time: date);

          return MonthlyPrayersDayRow(
            day: date.day,
            isToday: date.day == now.day,
            isFriday: date.weekday == DateTime.friday,
            values: [
              state.formatTime(times.fajr),
              state.formatTime(times.sunrise),
              state.formatTime(times.dhuhr),
              state.formatTime(times.asr),
              state.formatTime(times.maghrib),
              state.formatTime(times.isha),
            ],
          );
        },
      ),
    );
  }
}
