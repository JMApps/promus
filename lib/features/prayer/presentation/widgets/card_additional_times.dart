import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CardAdditionalTimes extends StatelessWidget {
  const CardAdditionalTimes({
    super.key,
    required this.eventName,
    required this.progress,
    required this.remainingTime,
  });

  final String eventName;
  final double progress;
  final DateTime remainingTime;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        size: 85,
        startAngle: 270,
        angleRange: 360,
        counterClockwise: true,
        customWidths: CustomSliderWidths(
          progressBarWidth: AppSpacing.small,
          shadowWidth: 0,
        ),
        customColors: CustomSliderColors(
          trackColor: appColors.primaryContainer,
          progressBarColor: appColors.primary,
          dotColor: appColors.primaryContainer,
        ),
      ),
      min: 0,
      max: 100,
      initialValue: 75,
      innerWidget: (_) => Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          Text(
            eventName,
            style: AppTextStyles.small,
          ),
          Text(
            DateFormat('HH:mm').format(remainingTime),
            style: AppTextStyles.small,
          ),
        ],
      ),
    );
  }
}
