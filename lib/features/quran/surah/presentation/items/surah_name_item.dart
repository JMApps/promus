import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/font_families.dart';
import '../../../../../core/routes/names_router.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../main/states/page_number_state.dart';
import '../../../reader/data/args/reader_args.dart';
import '../../../settings/states/reading_settings_state.dart';
import '../../domain/entities/surah_name_entity.dart';

class SurahNameItem extends StatelessWidget {
  const SurahNameItem({
    super.key,
    required this.surah,
    required this.index,
  });

  final SurahNameEntity surah;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.primary.withAlpha(25);
    final itemEvenColor = appColors.primary.withAlpha(05);
    return InkWell(
      onTap: () {
        context.read<PageNumberState>().setPageNumber(surah.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageReader,
          arguments: ReaderArgs(pageNumber: surah.startPageNumber),
        );
      },
      child: Container(
        padding: AppPaddings.hrSmallVrLarge,
        decoration: BoxDecoration(
          color: index.isOdd ? itemEvenColor : itemOddColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Text(
                surah.surahNumber.toString(),
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Selector<ReadingSettingsState, ({bool arabic, bool translation})>(
                    selector: (_, state) => (
                      arabic: state.arabicNameSurah,
                      translation: state.translationNameSurah,
                    ),
                    builder: (context, settings, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (settings.arabic)
                            Text(
                              FontFamilies.glyphForSurahNumber(
                                surah.surahNumber,
                              ),
                              style: TextStyle(
                                color: appColors.primary,
                                fontFamily: FontFamilies.surahHeader,
                                fontSize: 27.5,
                                height: 1,
                              ),
                            ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  surah.nameTranscription,
                                  style: AppTextStyles.medium,
                                  maxLines: 1,
                                ),
                              ),
                              if (settings.translation)
                                Flexible(
                                  child: Text(
                                    ' (${surah.nameTranslation})',
                                    style: AppTextStyles.medium,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  Text(
                    '${AppStrings.ayahsCount(surah.ayahsCount).toString()} • ${surah.revelationPlace == 0 ? 'Мекка' : 'Медина'}',
                    style: AppTextStyles.small,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Text(
              'Стр.\n${surah.startPageNumber}',
              style: AppTextStyles.small.copyWith(
                color: appColors.secondary,
              ),
              textAlign: .center,
            ),
            const SizedBox(width: AppSpacing.small),
          ],
        ),
      ),
    );
  }
}
