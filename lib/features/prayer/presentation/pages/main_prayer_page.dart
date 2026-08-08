import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promus/features/prayer/presentation/lists/week_days_row.dart';
import 'package:promus/features/prayer/presentation/widgets/main_city_cupertino_button.dart';
import 'package:promus/features/prayer/presentation/widgets/main_date_card_item.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/main_cupretino_button.dart';
import '../widgets/main_icon_item.dart';

class MainPrayerPage extends StatelessWidget {
  const MainPrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const .only(
        left: AppSpacing.small,
        right: AppSpacing.small,
        bottom: kBottomNavigationBarHeight + AppSpacing.small,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Card(
            child: Row(
              children: [
                Expanded(
                  child: MainCityCupertinoButton(
                    cityText: 'Izmir',
                    onPressed: () {},
                  ),
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathParams,
                  iconColor: appColors.tertiary,
                  onPressed: () {},
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathCalendar,
                  iconColor: appColors.secondary,
                  onPressed: () {},
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathQiblah,
                  iconColor: appColors.secondary,
                  onPressed: () {},
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathNotifications,
                  iconColor: appColors.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          MainDateCardItem(
            dateText: '26 august 2026',
            itemColor: appColors.primaryContainer,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.small),
          MainDateCardItem(
            dateText: '15 safar 1449',
            itemColor: appColors.secondaryContainer,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.small),
          WeekDaysRow(weekDay: DateTime.now().weekday),
          const SizedBox(height: AppSpacing.small),
          Card(
            child: Padding(
              padding: AppPaddings.medium,
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  Flexible(
                    child: EasyStepper(
                      verticalAlignment: .start,
                      activeStep: 1,
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
                      steps: const [
                        EasyStep(
                          icon: Icon(CupertinoIcons.sparkles),
                          customTitle: Text(
                            'Фаджр\n03:56',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.sun_max_fill),
                          customTitle: Text(
                            'Зухр\n12:41',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.sun_min_fill),
                          customTitle: Text(
                            '\'Аср\n16:28',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.sunset_fill),
                          customTitle: Text(
                            'Магриб\n19:42',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.moon_stars_fill),
                          customTitle: Text(
                            '\'Иша\n21:16',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        SleekCircularSlider(
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
                          max: 100,
                          initialValue: 75,
                          innerWidget: (_) => const Column(
                            mainAxisSize: .min,
                            mainAxisAlignment: .center,
                            children: [
                              Text(
                                'Фаджр',
                                style: AppTextStyles.medium,
                              ),
                              Text(
                                '00:23',
                                style: AppTextStyles.medium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            startAngle: 270,
                            angleRange: 360,
                            counterClockwise: true,
                            customWidths: CustomSliderWidths(
                              progressBarWidth: AppSpacing.medium,
                              shadowWidth: 0,
                            ),
                            customColors: CustomSliderColors(
                              trackColor: appColors.tertiaryContainer,
                              progressBarColor: appColors.tertiary,
                              dotColor: appColors.tertiaryContainer,
                            ),
                          ),
                          min: 0,
                          max: 100,
                          initialValue: 75,
                          innerWidget: (_) => const Column(
                            mainAxisSize: .min,
                            mainAxisAlignment: .center,
                            children: [
                              Text(
                                'Зухр',
                                style: AppTextStyles.medium,
                              ),
                              Text(
                                '-06:23',
                                style: AppTextStyles.medium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Card(
            elevation: 0,
            color: appColors.primaryContainer,
            child: ListTile(
              onTap: () {},
              shape: AppShapes.medium,
              splashColor: appColors.secondaryContainer,
              visualDensity: .compact,
              contentPadding: const .symmetric(horizontal: AppSpacing.medium),
              title: const Text('Время утренних азкаров'),
              leading: MainIconItem(
                iconPath: IconPaths.iconPathHands,
                iconColor: appColors.secondary,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: appColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Card(
            child: Padding(
              padding: AppPaddings.mediumBottomSmall,
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children: [
                  Flexible(
                    child: EasyStepper(
                      verticalAlignment: .start,
                      activeStep: 1,
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
                      steps: const [
                        EasyStep(
                          icon: Icon(CupertinoIcons.sunrise_fill),
                          customTitle: Text(
                            'Восход\n03:56',
                            textAlign: .center,
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.moon_fill),
                          customTitle: Text(
                            'Полночь\n12:41',
                            textAlign: .center,
                          ),
                        ),
                        EasyStep(
                          icon: Icon(Icons.donut_small),
                          customTitle: Text(
                            'Треть\n16:28',
                            textAlign: .center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.large),
                  SleekCircularSlider(
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
                    innerWidget: (_) => const Column(
                      mainAxisSize: .min,
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          'Полночь',
                          style: AppTextStyles.small,
                        ),
                        Text(
                          '-06:23',
                          style: AppTextStyles.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium * 2),
        ],
      ),
    );
  }
}
