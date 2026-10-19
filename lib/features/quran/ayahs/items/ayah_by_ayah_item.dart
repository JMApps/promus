import 'package:flutter/material.dart';

import '../../../../../core/constants/font_families.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/mushaf_page_entity.dart';
import '../widgets/ayah_item_option.dart';

class AyahByAyahItem extends StatelessWidget {
  const AyahByAyahItem({
    super.key,
    required this.row,
    required this.index,
  });

  final MushafPageEntity row;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    final surahNumber = row.glyphSurahNumber ?? row.surahNumber;
    final ayahNumber = row.glyphAyahNumber;

    final verseKey = surahNumber != null && ayahNumber != null ? '$surahNumber:$ayahNumber' : '';

    return RepaintBoundary(
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => AyahItemOption(
              ayahId: row.ayahId!,
              wholeAyah: '${row.arabicAyah}\n\n${row.translation}',
              verseKey: verseKey,
              ayahIndex: index,
            ),
          );
        },
        child: Container(
          padding: AppPaddings.hrSmallVrLarge,
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                width: 0.25,
                color: Colors.grey,
              ),
            ),
          ),
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
                child: Text(verseKey),
              ),
              if (row.arabicAyah != null && row.arabicAyah!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.medium),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    row.arabicAyah!,
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
              if (row.translation != null && row.translation!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.medium),
                Text(
                  row.translation!,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontFamily: FontFamilies.ptSans,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
