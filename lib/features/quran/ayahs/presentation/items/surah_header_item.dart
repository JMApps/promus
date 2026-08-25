import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/font_families.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../surah/presentation/states/surah_name_state.dart';

class SurahHeaderItem extends StatelessWidget {
  const SurahHeaderItem({
    super.key,
    required this.surahNumber,
  });

  final int surahNumber;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final String surahNameTranscription = context.read<SurahNameState>().surahByNumber(surahNumber: surahNumber)!.nameTranscription;
    return Container(
      padding: AppPaddings.medium,
      margin: AppPaddings.medium,
      width: double.infinity,
      alignment: .center,
      decoration: BoxDecoration(
        color: appColors.inversePrimary.withAlpha(75),
        borderRadius: AppRadius.medium
      ),
      child: Column(
        children: [
          Text(
            surahNameTranscription,
            style: TextStyle(
              fontSize: 19.0,
              fontFamily: FontFamilies.ptSans,
              color: appColors.primary,
            ),
            textAlign: .center,
            overflow: .ellipsis,
          ),
        ],
      ),
    );
  }
}
