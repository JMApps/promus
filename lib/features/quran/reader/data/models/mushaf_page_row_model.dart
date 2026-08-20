import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/enums/line_type.dart';

class MushafPageRowModel {
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

  const MushafPageRowModel({
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

  factory MushafPageRowModel.fromMap(Map<String, Object?> map) {
    return MushafPageRowModel(
      lineNumber: map[ColumnNames.lineNumber] as int,
      lineType: LineType.fromDb(map[ColumnNames.lineType] as String),
      isCentered: (map[ColumnNames.isCentered] as int) == 1,
      surahNumber: map[ColumnNames.numberSurah] as int?,
      firstWordId: map[ColumnNames.firstWordId] as int?,
      lastWordId: map[ColumnNames.lastWordId] as int?,
      glyphId: map[ColumnNames.id] as int?,
      glyphSurahNumber: map[ColumnNames.surahNumber] as int?,
      glyphAyahNumber: map[ColumnNames.ayahNumber] as int?,
      glyphWordNumber: map[ColumnNames.wordNumber] as int?,
      glyph: map[ColumnNames.glyph] as String?,
      word: map[ColumnNames.word] as String?,
      ayahId: map[ColumnNames.ayahId] as int?,
      arabicAyah: map['arabic_ayah'] as String?,
      translation: map['translation'] as String?,
    );
  }
}
