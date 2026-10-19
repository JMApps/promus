import '../../domain/entities/mushaf_page_entity.dart';
import '../models/mushaf_page_model.dart';

extension MushafPageMapper on MushafPageModel {
  MushafPageEntity mushafPageToEntity() {
    return MushafPageEntity(
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
