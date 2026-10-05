import 'package:equatable/equatable.dart';

import '../../../../core/enums/line_type.dart';

class MushafPageRowEntity extends Equatable {
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final int? firstWordId;
  final int? lastWordId;
  final int? glyphId;
  final int? glyphSurahNumber;
  final int? glyphAyahNumber;
  final int? glyphWordNumber;
  final String? glyph;
  final String? word;
  final int? ayahId;
  final String? arabicAyah;
  final String? translation;

  const MushafPageRowEntity({
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.surahNumber,
    this.firstWordId,
    this.lastWordId,
    this.glyphId,
    this.glyphSurahNumber,
    this.glyphAyahNumber,
    this.glyphWordNumber,
    this.glyph,
    this.word,
    this.ayahId,
    this.arabicAyah,
    this.translation,
  });

  @override
  List<Object?> get props => [
    lineNumber,
    lineType,
    isCentered,
    surahNumber,
    firstWordId,
    lastWordId,
    glyphId,
    glyphSurahNumber,
    glyphAyahNumber,
    glyphWordNumber,
    glyph,
    word,
    ayahId,
    arabicAyah,
    translation,
  ];
}
