import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class LoadDataWidget extends StatelessWidget {
  const LoadDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          Text(
            AppStrings.loadData,
            style: AppTextStyles.medium,
            textAlign: .center,
          ),
          SizedBox(height: AppSpacing.medium),
          CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
