import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_text_styles.dart';

class AyahTextSizeSlider extends StatelessWidget {
  const AyahTextSizeSlider({
    super.key,
    required this.title,
    required this.size,
    required this.onChanged,
  });

  final String title;
  final double size;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: .adaptivePlatformDensity,
      contentPadding: .zero,
      horizontalTitleGap: 0,
      title: Padding(
        padding: AppPaddings.hrMedium,
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.medium,
            ),
            Expanded(
              child: Slider(
                showValueIndicator: .onDrag,
                value: size,
                label: size.round().toString(),
                min: 14.0,
                max: 120.0,
                onChanged: onChanged,
              ),
            ),
            Text(
              size.round().toString(),
              style: AppTextStyles.medium,
            ),
          ],
        ),
      ),
    );
  }
}
