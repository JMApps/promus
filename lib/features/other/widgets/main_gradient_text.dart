import 'package:flutter/material.dart';

import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_shapes.dart';
import '../../../core/theme/app_text_styles.dart';

class MainGradientText extends StatelessWidget {
  const MainGradientText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Ink(
      decoration: ShapeDecoration(
        shape: AppShapes.medium,
        gradient: LinearGradient(
          colors: [
            appColors.primaryContainer,
            appColors.tertiaryContainer,
            appColors.secondaryContainer,
          ],
        ),
      ),
      child: Padding(
        padding: AppPaddings.hrMediumVrSmall,
        child: Text(
          text,
          style: AppTextStyles.medium,
        ),
      ),
    );
  }
}
