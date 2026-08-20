import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/font_families.dart';
import '../../../../../core/routes/names_router.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../ayahs/domain/entities/ayah_by_ayah_entity.dart';
import '../../../main/states/page_number_state.dart';
import '../../../reader/data/args/reader_args.dart';
import '../../../settings/states/reading_settings_state.dart';
class FavoriteAyahItem extends StatelessWidget {
  const FavoriteAyahItem({
    super.key,
    required this.ayahByAyahModel,
    required this.index,
  });

  final AyahByAyahEntity ayahByAyahModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.read<PageNumberState>().setPageNumber(ayahByAyahModel.ayahPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageReader,
          arguments: ReaderArgs(pageNumber: ayahByAyahModel.ayahPageNumber),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Container();
          },
        );
      },
      child: Container(
        padding: AppPaddings.hrSmallVrLarge,
        decoration: const BoxDecoration(
          border: .symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: Colors.grey,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .start,
              children: [
                Container(
                  width: 65,
                  padding: AppPaddings.small,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: appColors.secondaryContainer.withAlpha(155),
                    borderRadius: AppRadius.small,
                  ),
                  child: Text(ayahByAyahModel.verseKey),
                ),
              ],
            ),
            Consumer<ReadingSettingsState>(
              builder: (context, readingSettingsState, _) {
                return Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(height: readingSettingsState.isArabicAyahShow ? AppSpacing.medium : 0),
                    Visibility(
                      visible: readingSettingsState.isArabicAyahShow,
                      child: Text(
                        ayahByAyahModel.ayahArabic,
                        textDirection: .rtl,
                        style: TextStyle(
                          fontSize: readingSettingsState.ayahArabicTextSize,
                          fontFamily: FontFamilies.uthmanic,
                          height: 2.25,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: readingSettingsState.isTranslationAyahShow ? AppSpacing.medium : 0),
                    Visibility(
                      visible: readingSettingsState.isTranslationAyahShow,
                      child: Text(
                        ayahByAyahModel.ayahTranslation,
                        style: TextStyle(
                          fontSize: readingSettingsState.ayahTranslationTextSize,
                          fontFamily: FontFamilies.ptSans,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
