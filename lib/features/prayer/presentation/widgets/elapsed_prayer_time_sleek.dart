import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ElapsedPrayerTimeSleek extends StatelessWidget {
  const ElapsedPrayerTimeSleek({
    super.key,
    required this.prayerName,
    required this.progress,
    required this.timeText,
  });

  final String prayerName;
  final double progress;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        startAngle: 270,
        angleRange: 360,
        counterClockwise: false,
        customWidths: CustomSliderWidths(
          progressBarWidth: AppSpacing.medium,
          shadowWidth: 0,
        ),
        customColors: CustomSliderColors(
          trackColor: appColors.secondaryContainer,
          progressBarColor: appColors.secondary,
          dotColor: appColors.secondaryContainer,
        ),
      ),
      min: 0,
      max: 1.0,
      initialValue: progress,
      innerWidget: (_) => Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          Text(
            prayerName,
            style: AppTextStyles.medium,
          ),
          Text(
            timeText,
            style: AppTextStyles.medium,
          ),
        ],
      ),
    );
  }
}
