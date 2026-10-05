import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/font_families.dart';
import '../../../../../core/routes/names_router.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_shapes.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../data/args/reader_args.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../settings/states/reading_settings_state.dart';

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
    return Card(
      margin: AppPaddings.withoutTopSmall,
      elevation: 0,
      color: index.isOdd ? itemEvenColor : itemOddColor,
      child: ListTile(
        onTap: () {
          //context.read<PageNumberState>().setPageNumber(surah.startPageNumber);
          Navigator.pushNamed(
            context,
            NamesRouter.pageReader,
            arguments: ReaderArgs(pageNumber: surah.startPageNumber),
          );
        },
        shape: AppShapes.medium,
        contentPadding: AppPaddings.hrMedium,
        leading: CircleAvatar(
          radius: 17.5,
          backgroundColor: appColors.inversePrimary,
          child: Text(
            surah.surahNumber.toString(),
            style: AppTextStyles.small.copyWith(
              fontSize: 14.0,
            ),
          ),
        ),
        title: Selector<ReadingSettingsState, ({bool arabic, bool translation})>(
          selector: (_, state) => (
            arabic: state.arabicNameSurah,
            translation: state.translationNameSurah,
          ),
          builder: (context, settings, _) {
            return Column(
              crossAxisAlignment: .stretch,
              children: [
                if (settings.arabic)
                  Text(
                    FontFamilies.glyphForSurahNumber(surah.surahNumber),
                    style: TextStyle(
                      color: appColors.primary,
                      fontFamily: FontFamilies.surahHeader,
                      fontSize: 25.0,
                      height: 1,
                    ),
                  ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        surah.nameTranscription,
                        style: AppTextStyles.medium.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: .ellipsis,
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
        subtitle: Text(
          '${AppStrings.ayahsCount(surah.ayahsCount)} • '
          '${surah.revelationPlace == 0 ? AppStrings.mecca : AppStrings.medina}',
          style: AppTextStyles.small,
          maxLines: 1,
          overflow: .ellipsis,
        ),
        trailing: Text(
          '${AppStrings.strShort}\n${surah.startPageNumber}',
          style: AppTextStyles.small.copyWith(
            color: appColors.secondary,
          ),
          textAlign: .center,
        ),
      ),
    );
  }
}
