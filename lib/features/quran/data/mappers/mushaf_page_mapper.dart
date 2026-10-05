import '../../domain/entities/mushaf_page_row_entity.dart';
import '../models/mushaf_page_row_model.dart';

extension MushafPageRowMapper on MushafPageRowModel {
  MushafPageRowEntity mushafPageRowToEntity() {
    return MushafPageRowEntity(
      lineNumber: lineNumber,
      lineType: lineType,
      isCentered: isCentered,
      surahNumber: surahNumber,
      firstWordId: firstWordId,
      lastWordId: lastWordId,
      glyphId: glyphId,
      glyphSurahNumber: glyphSurahNumber,
      glyphAyahNumber: glyphAyahNumber,
      glyphWordNumber: glyphWordNumber,
      glyph: glyph,
      word: word,
      ayahId: ayahId,
      arabicAyah: arabicAyah,
      translation: translation,
    );
  }
}
