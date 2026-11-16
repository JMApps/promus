import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../other/widgets/main_gradient_text.dart';
import '../widgets/asr_method_selector.dart';
import '../widgets/correct_prayer_minutes.dart';
import '../widgets/dst_format_mode_segment.dart';
import '../widgets/high_latitude_selector.dart';
import '../widgets/main_city_cupertino_button.dart';
import '../widgets/prayer_methods_selector.dart';
import '../widgets/time_format_mode_segment.dart';

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
          spacing: AppSpacing.medium,
          children: [
            MainGradientText(text: AppStrings.selectedCity),
            MainCityCupertinoButton(),
            MainGradientText(text: AppStrings.prayerMethodCalculate),
            PrayerMethodsSelector(),
            MainGradientText(text: AppStrings.highLatitude),
            HighLatitudeSelector(),
            MainGradientText(text: AppStrings.asrMethod),
            AsrMethodSelector(),
            MainGradientText(text: AppStrings.timeModeLabel),
            TimeFormatModeSegment(),
            MainGradientText(text: AppStrings.winterTime),
            DSTFormatModeSegment(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
