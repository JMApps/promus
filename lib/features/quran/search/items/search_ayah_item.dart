import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../ayahs/widgets/ayah_item_option.dart';
import '../../data/args/reader_args.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../states/mushaf_page_number_state.dart';
import '../widgets/ayah_info_text.dart';
import '../widgets/highlighted_ayah_text.dart';

class SearchAyahItem extends StatelessWidget {
  const SearchAyahItem({
    super.key,
    required this.ayah,
    required this.index,
    required this.query,
  });

  final AyahByAyahEntity ayah;
  final int index;
  final String query;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        context.read<MushafPageNumberState>().setPageNumber(
          ayah.ayahPageNumber,
        );
        Navigator.pushNamed(
          context,
          NamesRouter.pageReader,
          arguments: ReaderArgs(
            pageNumber: ayah.ayahPageNumber,
            verseKey: ayah.verseKey,
          ),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => AyahItemOption(
            ayahId: ayah.ayahId,
            wholeAyah: '${ayah.ayahArabic}\n\n${ayah.ayahTranslation}',
            verseKey: ayah.verseKey,
            ayahIndex: index,
          ),
        );
      },
      child: Container(
        padding: AppPaddings.medium,
        decoration: BoxDecoration(
          border: .symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: appColors.outlineVariant,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            HighlightedAyahText(
              text: ayah.ayahArabic,
              query: query,
              isArabic: true,
            ),
            const SizedBox(height: AppSpacing.medium),
            HighlightedAyahText(
              text: ayah.ayahTranslation,
              query: query,
              isArabic: false,
            ),
            const SizedBox(height: AppSpacing.medium),
            AyahInfoText(
              verseKey: ayah.verseKey,
            ),
          ],
        ),
      ),
    );
  }
}
