import 'package:flutter/material.dart';

import '../../../../../core/enums/line_type.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../ayahs/presentation/items/basmallah_item.dart';
import '../../../ayahs/presentation/items/surah_header_item.dart';
import '../../domain/entities/mushaf_page_row_entity.dart';
import '../items/mushaf_glyph_line_item.dart';

class MushafGlyphPageList extends StatelessWidget {
  const MushafGlyphPageList({
    super.key,
    required this.pageNumber,
    required this.rows,
  });

  final int pageNumber;
  final List<MushafPageRowEntity> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final lines = _buildLines(rows);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Center(
            child: SingleChildScrollView(
              padding: AppPaddings.topMediumSmallOther,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  for (final line in lines)
                    switch (line) {
                      _SurahHeaderLine(:final surahNumber) => SurahHeaderItem(
                        surahNumber: surahNumber,
                      ),
                      _BasmallahLine() => const BasmallahItem(),
                      _GlyphLine(:final rows) => MushafGlyphLineItem(
                        pageNumber: pageNumber,
                        rows: rows,
                      ),
                    },
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static List<_MushafLine> _buildLines(List<MushafPageRowEntity> rows) {
    final sortedRows = [...rows]
      ..sort((a, b) {
        final lineCompare = a.lineNumber.compareTo(b.lineNumber);
        if (lineCompare != 0) return lineCompare;

        return (a.glyphId ?? 0).compareTo(b.glyphId ?? 0);
      });

    final groupedByLine = <int, List<MushafPageRowEntity>>{};

    for (final row in sortedRows) {
      groupedByLine.putIfAbsent(row.lineNumber, () => []).add(row);
    }

    final result = <_MushafLine>[];

    for (final entry in groupedByLine.entries) {
      final lineRows = entry.value;
      final first = lineRows.first;

      switch (first.lineType) {
        case LineType.surahName:
          final surahNumber = first.surahNumber;
          if (surahNumber != null) {
            result.add(_SurahHeaderLine(surahNumber));
          }

        case LineType.basmallah:
          result.add(const _BasmallahLine());

        case LineType.ayah:
          final glyphRows = lineRows
              .where((row) => row.glyph != null && row.glyph!.isNotEmpty)
              .toList(growable: false);

          if (glyphRows.isNotEmpty) {
            result.add(_GlyphLine(glyphRows));
          }
      }
    }

    return result;
  }
}

sealed class _MushafLine {
  const _MushafLine();
}

final class _SurahHeaderLine extends _MushafLine {
  const _SurahHeaderLine(this.surahNumber);

  final int surahNumber;
}

final class _BasmallahLine extends _MushafLine {
  const _BasmallahLine();
}

final class _GlyphLine extends _MushafLine {
  const _GlyphLine(this.rows);

  final List<MushafPageRowEntity> rows;
}
