import 'package:equatable/equatable.dart';

import '../../../../../core/enums/line_type.dart';
import 'glyph_entity.dart';

class PageLineEntity extends Equatable {
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final List<GlyphEntity> glyphs;

  const PageLineEntity({
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.surahNumber,
    required this.glyphs,
  });

  @override
  List<Object?> get props => [
    lineNumber,
    lineType,
    isCentered,
    surahNumber,
    glyphs,
  ];
}
