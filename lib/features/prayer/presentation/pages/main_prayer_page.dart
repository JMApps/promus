import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../main/widgets/main_icon_item.dart';

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
                  child: CupertinoButton(
                    padding: const .symmetric(
                      horizontal: AppSpacing.small,
                      vertical: AppSpacing.small,
                    ),
                    child: Row(
                      children: [
                        MainIconItem(
                          iconPath: IconPaths.iconPathLocation,
                          iconColor: appColors.error,
                        ),
                        const SizedBox(width: AppSpacing.xSmall),
                        Flexible(
                          child: Text(
                            'Izmir',
                            style: AppTextStyles.medium.copyWith(color: appColors.secondary),
                            overflow: .ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ),
                CupertinoButton(
                  padding: .zero,
                  child: MainIconItem(
                    iconPath: IconPaths.iconPathParams,
                    iconColor: appColors.tertiary,
                  ),
                  onPressed: () {},
                ),
                CupertinoButton(
                  padding: .zero,
                  child: MainIconItem(
                    iconPath: IconPaths.iconPathCalendar,
                    iconColor: appColors.secondary,
                  ),
                  onPressed: () {},
                ),
                CupertinoButton(
                  padding: .zero,
                  child: MainIconItem(
                    iconPath: IconPaths.iconPathQiblah,
                    iconColor: appColors.secondary,
                  ),
                  onPressed: () {},
                ),
                CupertinoButton(
                  padding: const .only(right: AppSpacing.small),
                  child: MainIconItem(
                    iconPath: IconPaths.iconPathNotifications,
                    iconColor: appColors.secondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Card(
            elevation: 0,
            color: appColors.primaryContainer,
            child: ListTile(
              onTap: () {},
              visualDensity: .compact,
              shape: AppShapes.medium,
              dense: true,
              minVerticalPadding: 0,
              minTileHeight: 0,
              splashColor: appColors.secondaryContainer,
              contentPadding: const .symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
              title: const Text(
                '27 июнь, 2026',
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Card(
            color: appColors.secondaryContainer,
            elevation: 0,
            child: ListTile(
              onTap: () {},
              visualDensity: .compact,
              shape: AppShapes.medium,
              dense: true,
              minVerticalPadding: 0,
              minTileHeight: 0,
              splashColor: appColors.secondaryContainer,
              contentPadding: const .symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
              title: const Text(
                '15 сафар, 1448',
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          SizedBox(
            height: 35,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Card(
                  child: Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text('Пн'),
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text('Вт'),
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text('Ср'),
                  ),
                ),
                Card(
                  color: appColors.inversePrimary,
                  child: const Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text(
                      'Чт',
                    ),
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text('Пт'),
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text('Сб'),
                  ),
                ),
                const Card(
                  child: Padding(
                    padding: AppPaddings.hrMediumVrXSmall,
                    child: Text('Вс'),
                  ),
                ),
              ],
            ),
          ),
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
