import 'package:flutter/material.dart';
import 'package:promus/features/other/widgets/main_gradient_text.dart';
import 'package:promus/features/prayer/presentation/widgets/asr_method_selector.dart';
import 'package:promus/features/prayer/presentation/widgets/high_latitude_selector.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/prayer_methods_selector.dart';

class PrayerParamsPage extends StatelessWidget {
  const PrayerParamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.params),
      ),
      body: const SingleChildScrollView(
        padding: AppPaddings.medium,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            SizedBox(height: AppSpacing.small),
            MainGradientText(text: 'Методы расчета времени молитв'),
            SizedBox(height: AppSpacing.small),
            PrayerMethodsSelector(),
            SizedBox(height: AppSpacing.small),
            MainGradientText(text: 'Широкие высоты'),
            SizedBox(height: AppSpacing.small),
            HighLatitudeSelector(),
            SizedBox(height: AppSpacing.small),
            MainGradientText(text: 'Молитва \'аср'),
            SizedBox(height: AppSpacing.small),
            AsrMethodSelector(),
            SizedBox(height: AppSpacing.small),
          ],
        ),
      ),
    );
  }
}
