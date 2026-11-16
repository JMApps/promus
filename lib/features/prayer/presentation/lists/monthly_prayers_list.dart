import 'package:material_ui/material_ui.dart';
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
    context.select((PrayerState state) => (
    state.coordinates,
    state.calculationParameters,
    state.use24HourFormat,
    ));

    final today = context.select(
          (TimeState state) => DateUtils.dateOnly(state.getDateTime),
    );

    final prayerState = Provider.of<PrayerState>(context, listen: false);
    final daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);

    return Scrollbar(
      controller: _controller,
      child: ListView.separated(
        controller: _controller,
        itemCount: daysInMonth,
        separatorBuilder: (context, index) =>
        const Divider(height: _dividerHeight),
        itemBuilder: (context, index) {
          final date = DateTime(today.year, today.month, index + 1);
          final times = prayerState.prayerTimeSchedule(time: date);

          return MonthlyPrayersDayRow(
            day: date.day,
            isToday: date.day == today.day,
            isFriday: date.weekday == DateTime.friday,
            values: [
              prayerState.formatTime(times.fajr, compact: true),
              prayerState.formatTime(times.sunrise, compact: true),
              prayerState.formatTime(times.dhuhr, compact: true),
              prayerState.formatTime(times.asr, compact: true),
              prayerState.formatTime(times.maghrib, compact: true),
              prayerState.formatTime(times.isha, compact: true),
            ],
          );
        },
      ),
    );
  }
}
