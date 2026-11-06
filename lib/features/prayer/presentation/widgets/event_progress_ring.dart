import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/sleek_entity.dart';
import '../../state/prayer_state.dart';
import 'card_additional_times.dart';

class EventProgressRing extends StatelessWidget {
  const EventProgressRing({super.key});

  @override
  Widget build(BuildContext context) {
    final event = context.select<PrayerState, SleekEntity>((s) => s.event);
    return CardAdditionalTimes(
      eventName: event.name,
      progress: event.progress,
      timeText: event.timeText,
    );
  }
}
