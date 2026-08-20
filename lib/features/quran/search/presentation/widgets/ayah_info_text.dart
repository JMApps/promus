import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../surah/presentation/states/surah_name_state.dart';

class AyahInfoText extends StatelessWidget {
  const AyahInfoText({
    super.key,
    required this.verseKey,
  });

  final String verseKey;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final surahState = context.read<SurahNameState>();
    final surahInfo = surahState.surahByVerseKey(
      'Сура',
      verseKey,
      'Аят'.toLowerCase(),
    );
    return Text(
      surahInfo ?? verseKey,
      style: AppTextStyles.small.copyWith(
        color: appColors.onSurface.withAlpha(155),
      ),
    );
  }
}
