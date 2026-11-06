import 'package:adhan/adhan.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class EventTimesStepper extends StatelessWidget {
  const EventTimesStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final (:times, :sunnah, :step) = context.select<PrayerState, ({PrayerTimes times, SunnahTimes sunnah, int step})>((s) => (
        times: s.prayerTimes,
        sunnah: s.sunnahTimes,
        step: s.currentEventStep,
      ),
    );
    final format = context.read<PrayerState>().formatTime;
    final appColors = Theme.of(context).colorScheme;

    EasyStep stepOf(IconData icon, String name, DateTime time) => EasyStep(
      icon: Icon(icon),
      customTitle: Text('$name\n${format(time)}', textAlign: .center),
    );

    return EasyStepper(
      verticalAlignment: .start,
      activeStep: step,
      direction: .horizontal,
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
        lineLength: .infinity,
        lineType: .dotted,
        unreachedLineType: .dotted,
      ),
      steps: [
        stepOf(
          CupertinoIcons.sunrise_fill,
          AppStrings.sunrise,
          times.sunrise,
        ),
        stepOf(
          CupertinoIcons.moon_fill,
          AppStrings.midnight,
          sunnah.middleOfTheNight,
        ),
        stepOf(
          Icons.donut_small,
          AppStrings.lastThirdNight,
          sunnah.lastThirdOfTheNight,
        ),
      ],
    );
  }
}
