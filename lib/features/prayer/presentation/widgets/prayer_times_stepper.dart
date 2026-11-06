import 'package:adhan/adhan.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class PrayerTimesStepper extends StatelessWidget {
  const PrayerTimesStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final (:times, :step) = context.select<PrayerState, ({PrayerTimes times, int step})>((s) => (times: s.prayerTimes, step: s.currentPrayerStep));
    final format = context.read<PrayerState>().formatTime;
    final appColors = Theme.of(context).colorScheme;

    EasyStep stepOf(IconData icon, String name, DateTime time) => EasyStep(
      icon: Icon(icon),
      customTitle: Text('$name\n${format(time)}'),
    );

    return EasyStepper(
      verticalAlignment: .start,
      activeStep: step,
      direction: .vertical,
      showTitle: true,
      showLoadingAnimation: false,
      stepRadius: AppSpacing.large,
      finishedStepBackgroundColor: appColors.primary,
      activeStepBackgroundColor: appColors.tertiary,
      unreachedStepBorderColor: appColors.secondaryContainer,
      activeStepBorderColor: Colors.transparent,
      unreachedStepIconColor: appColors.secondaryContainer,
      activeStepIconColor: appColors.primaryContainer,
      borderThickness: 3.5,
      activeStepBorderType: .normal,
      unreachedStepBorderType: .normal,
      lineStyle: const LineStyle(
        lineType: .dotted,
        unreachedLineType: .dotted,
      ),
      steps: [
        stepOf(
          CupertinoIcons.sparkles,
          AppStrings.prayerFajr,
          times.fajr,
        ),
        stepOf(
          CupertinoIcons.sun_max_fill,
          AppStrings.prayerDhuhr,
          times.dhuhr,
        ),
        stepOf(
          CupertinoIcons.sun_min_fill,
          AppStrings.prayerAsr,
          times.asr,
        ),
        stepOf(
          CupertinoIcons.sunset_fill,
          AppStrings.prayerMaghrib,
          times.maghrib,
        ),
        stepOf(
          CupertinoIcons.moon_stars_fill,
          AppStrings.prayerIsha,
          times.isha,
        ),
      ],
    );
  }
}
