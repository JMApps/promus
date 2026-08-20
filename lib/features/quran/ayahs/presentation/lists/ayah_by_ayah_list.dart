import 'package:flutter/material.dart';

import '../../../../../core/enums/line_type.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../reader/domain/entities/mushaf_page_row_entity.dart';
import '../../domain/entities/page_line.dart';
import '../items/ayah_by_ayah_item.dart';
import '../items/basmallah_item.dart';
import '../items/surah_header_item.dart';

class AyahByAyahList extends StatelessWidget {
  const AyahByAyahList({
    super.key,
    required this.pageNumber,
    required this.rows,
    this.ayahPosition,
  });

  final int pageNumber;
  final List<MushafPageRowEntity> rows;
  final int? ayahPosition;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final lines = _buildLines(rows: rows);

    return ListView.builder(
      padding: AppPaddings.topMediumSmallOther,
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];

        return switch (line) {
          SurahLine(surahNumber: final surahNumber) => SurahHeaderItem(
            surahNumber: surahNumber,
          ),

          BasmallahLine() => const BasmallahItem(),

          AyahLine(row: final row, index: final ayahIndex) => AyahByAyahItem(
            row: row,
            index: ayahIndex,
          ),
        };
      },
    );
  }

  static List<PageLine> _buildLines({
    required List<MushafPageRowEntity> rows,
  }) {
    final lines = <PageLine>[];

    final sortedRows = [...rows]
      ..sort((a, b) {
        final lineCompare = a.lineNumber.compareTo(b.lineNumber);
        if (lineCompare != 0) return lineCompare;

        return (a.glyphId ?? 0).compareTo(b.glyphId ?? 0);
      });

    final handledAyahs = <String>{};
    var ayahIndex = 0;

    for (final row in sortedRows) {
      switch (row.lineType) {
        case LineType.surahName:
          final surahNumber = row.surahNumber;
          if (surahNumber != null) {
            lines.add(SurahLine(surahNumber));
          }

        case LineType.basmallah:
          lines.add(const BasmallahLine());

        case LineType.ayah:
          final surah = row.glyphSurahNumber;
          final ayah = row.glyphAyahNumber;

          if (surah == null || ayah == null) continue;

          final key = '$surah:$ayah';

          if (handledAyahs.contains(key)) continue;

          handledAyahs.add(key);

          lines.add(AyahLine(row, ayahIndex));
          ayahIndex++;
      }
    }

    final hasSurahNameFromLayout = sortedRows.any(
      (row) => row.lineType == LineType.surahName,
    );

    if (!hasSurahNameFromLayout && sortedRows.isNotEmpty) {
      final currentSurahNumber =
          sortedRows.first.glyphSurahNumber ?? sortedRows.first.surahNumber;

      if (currentSurahNumber != null) {
        lines.insert(0, SurahLine(currentSurahNumber));
      }
    }

    return lines;
  }
}
