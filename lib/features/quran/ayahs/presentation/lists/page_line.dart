import '../../../../../core/enums/line_type.dart';
import '../../../reader/domain/entities/glyph_entity.dart';

class PageLine {
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final List<GlyphEntity> glyphs;

  const PageLine({
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.surahNumber,
    required this.glyphs,
  });
}
