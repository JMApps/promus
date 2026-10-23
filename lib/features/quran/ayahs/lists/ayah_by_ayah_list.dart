import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../core/enums/line_type.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../domain/entities/mushaf_page_entity.dart';
import '../../domain/entities/page_line.dart';
import '../../search/widgets/ayah_flash_high_light.dart';
import '../items/ayah_by_ayah_item.dart';
import '../items/basmallah_item.dart';
import '../items/surah_header_item.dart';
import '../states/ayah_flash_state.dart';

class AyahByAyahList extends StatefulWidget {
  const AyahByAyahList({
    super.key,
    required this.rows,
    this.scrollToVerseKey,
  });

  final List<MushafPageEntity> rows;

  final String? scrollToVerseKey;

  @override
  State<AyahByAyahList> createState() => _AyahByAyahListState();

  static List<PageLine> _buildLines({
    required List<MushafPageEntity> rows,
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

class _AyahByAyahListState extends State<AyahByAyahList> {
  late List<PageLine> _lines;
  int _initialIndex = 0;
  String? _targetKey;

  @override
  void initState() {
    super.initState();
    _lines = AyahByAyahList._buildLines(rows: widget.rows);

    final index = _indexOfVerse(widget.scrollToVerseKey);
    if (index == null) return;

    _initialIndex = index;
    _targetKey = widget.scrollToVerseKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AyahFlashState>().flash();
    });
  }

  @override
  void didUpdateWidget(AyahByAyahList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.rows, widget.rows)) {
      _lines = AyahByAyahList._buildLines(rows: widget.rows);
    }
  }

  static String _verseKeyOf(AyahLine line) =>
      '${line.row.glyphSurahNumber}:${line.row.glyphAyahNumber}';

  int? _indexOfVerse(String? verseKey) {
    if (verseKey == null) return null;

    final index = _lines.indexWhere(
      (line) => line is AyahLine && _verseKeyOf(line) == verseKey,
    );

    return index < 0 ? null : index;
  }

  @override
  Widget build(BuildContext context) {
    if (_lines.isEmpty) {
      return const SizedBox.shrink();
    }

    return ScrollablePositionedList.builder(
      padding: AppPaddings.topMediumSmallOther,
      initialScrollIndex: _initialIndex,
      itemCount: _lines.length,
      itemBuilder: (context, index) {
        final line = _lines[index];

        final isTarget = _targetKey != null && line is AyahLine && _verseKeyOf(line) == _targetKey;

        final child = switch (line) {
          SurahLine(surahNumber: final surahNumber) => SurahHeaderItem(
            surahNumber: surahNumber,
          ),

          BasmallahLine() => const BasmallahItem(),

          AyahLine(row: final row, index: final ayahIndex) => AyahByAyahItem(
            row: row,
            index: ayahIndex,
          ),
        };

        return isTarget ? AyahFlashHighlight(child: child) : child;
      },
    );
  }
}
