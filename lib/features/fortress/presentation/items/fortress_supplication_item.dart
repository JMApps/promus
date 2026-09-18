import 'package:flutter/material.dart';

import '../../../../core/constants/font_families.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../widgets/main_html_widget.dart';
import '../widgets/supplication_option_card.dart';

class FortressSupplicationItem extends StatelessWidget {
  const FortressSupplicationItem({
    super.key,
    required this.supplicationModel,
    required this.supplicationsLength,
    required this.index,
  });

  final FortressSupplicationEntity supplicationModel;
  final int supplicationsLength;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.primary.withAlpha(35);
    final itemEvenColor = appColors.primary.withAlpha(15);
    return Card(
      margin: AppPaddings.withoutTopSmall,
      elevation: 0,
      color: index.isOdd ? itemEvenColor : itemOddColor,
      child: Padding(
        padding: AppPaddings.small,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            if (supplicationModel.arabicText != null) ...[
              Text(
                supplicationModel.arabicText!,
                style: const TextStyle(
                  fontSize: 19.0,
                  fontFamily: FontFamilies.uthmanic,
                  height: 1.85,
                ),
                textDirection: .rtl,
              ),
              const SizedBox(height: AppSpacing.small),
            ],
            if (supplicationModel.transcriptionText != null) ...[
              Text(
                supplicationModel.transcriptionText!,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: FontFamilies.ptSans,
                  color: appColors.secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
            ],
            MainHtmlWidget(
              htmlContent: supplicationModel.translationHtml,
              textAlign: .start,
            ),
            SupplicationOptionCard(
              supplicationModel: supplicationModel,
              supplicationsLength: supplicationsLength,
              index: index + 1,
            ),
          ],
        ),
      ),
    );
  }
}
