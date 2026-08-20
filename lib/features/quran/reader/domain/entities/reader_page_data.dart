import '../../../ayahs/domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/entities/glyph_entity.dart';
import '../../domain/entities/layout_entity.dart';

class ReaderPageData {
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
}