import 'package:flutter/material.dart';
import 'package:promus/features/prayer/presentation/widgets/correct_prayer_minutes.dart';
import 'package:promus/features/prayer/presentation/widgets/dst_mode_item.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../other/widgets/main_gradient_text.dart';
import '../widgets/asr_method_selector.dart';
import '../widgets/high_latitude_selector.dart';
import '../widgets/main_city_cupertino_button.dart';
import '../widgets/prayer_methods_selector.dart';

class PrayerParamsPage extends StatelessWidget {
  const PrayerParamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.params),
        actions: const [
          CorrectPrayerMinutes(),
        ],
      ),
      body: const SingleChildScrollView(
        padding: AppPaddings.hrSmallVrMedium,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            MainGradientText(text: AppStrings.selectedCity),
            SizedBox(height: AppSpacing.medium),
            MainCityCupertinoButton(),
            SizedBox(height: AppSpacing.medium),
            MainGradientText(text: AppStrings.prayerMethodCalculate),
            SizedBox(height: AppSpacing.medium),
            PrayerMethodsSelector(),
            SizedBox(height: AppSpacing.medium),
            MainGradientText(text: AppStrings.highLatitude),
            SizedBox(height: AppSpacing.medium),
            HighLatitudeSelector(),
            SizedBox(height: AppSpacing.medium),
            MainGradientText(text: AppStrings.asrMethod),
            SizedBox(height: AppSpacing.medium),
            AsrMethodSelector(),
            SizedBox(height: AppSpacing.medium),
            MainGradientText(text: AppStrings.winterTime),
            SizedBox(height: AppSpacing.medium),
            DstModeItem(),
            SizedBox(height: AppSpacing.medium),
          ],
        ),
      ),
    );
  }
}
