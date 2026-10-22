import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/font_families.dart';
import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../ayahs/widgets/ayah_item_option.dart';
import '../../data/args/reader_args.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../states/mushaf_page_number_state.dart';

class SearchAyahByAyahItem extends StatelessWidget {
  const SearchAyahByAyahItem({
    super.key,
    required this.ayah,
    required this.index,
  });

  final AyahByAyahEntity ayah;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          context.read<MushafPageNumberState>().setPageNumber(
            ayah.ayahPageNumber,
          );
          Navigator.pushNamed(
            context,
            NamesRouter.pageReader,
            arguments: ReaderArgs(pageNumber: ayah.ayahPageNumber),
          );
        },
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => AyahItemOption(
              ayahId: ayah.ayahId,
              wholeAyah: '${ayah.ayahArabic}\n\n${ayah.ayahTranslation}',
              verseKey: ayah.verseKey,
              ayahIndex: index,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: 65,
              padding: AppPaddings.small,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: appColors.secondaryContainer.withAlpha(155),
                borderRadius: AppRadius.small,
              ),
              child: Text(ayah.verseKey),
            ),
            if (ayah.ayahArabic.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.medium),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ayah.ayahArabic,
                  textDirection: .rtl,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontFamily: FontFamilies.uthmanic,
                    height: 2.25,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
            if (ayah.ayahTranslation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.medium),
              Text(
                ayah.ayahTranslation,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontFamily: FontFamilies.ptSans,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
