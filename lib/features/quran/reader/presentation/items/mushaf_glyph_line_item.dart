import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/mushaf_page_row_entity.dart';
import '../states/mushaf_page_font_state.dart';

class MushafGlyphLineItem extends StatelessWidget {
  const MushafGlyphLineItem({
    super.key,
    required this.pageNumber,
    required this.rows,
  });

  final int pageNumber;
  final List<MushafPageRowEntity> rows;

  @override
  Widget build(BuildContext context) {
    final fontState = context.watch<MushafPageFontState>();
    final family = fontState.getFontFamily(pageNumber);

    if (family == null) {
      return const SizedBox.shrink();
    }

    final text = rows
        .map((row) => row.glyph)
        .whereType<String>()
        .join('\u202F');
    return RepaintBoundary(
      child: Text(
        text,
        textDirection: .rtl,
        textAlign: .center,
        style: TextStyle(
          fontFamily: family,
          fontSize: 20,
          height: 1.9,
        ),
      ),
    );
  }
}
