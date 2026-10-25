import 'package:equatable/equatable.dart';

import 'ayah_by_ayah_entity.dart';
import 'glyph_entity.dart';
import 'layout_entity.dart';

class ReaderPageData extends Equatable {
  final int pageNumber;
  final List<LayoutEntity> layouts;
  final List<GlyphEntity> glyphs;
  final List<AyahByAyahEntity> ayahs;

  const ReaderPageData({
    required this.pageNumber,
    required this.layouts,
    required this.glyphs,
    required this.ayahs,
  });

  @override
  List<Object?> get props => [
    pageNumber,
    layouts,
    glyphs,
    ayahs,
  ];
}
