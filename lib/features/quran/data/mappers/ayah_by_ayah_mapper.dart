import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../models/ayah_by_ayah_model.dart';

extension AyahByAyahMapper on AyahByAyahModel {
  AyahByAyahEntity toEntity() {
    return AyahByAyahEntity(
      ayahId: ayahId,
      verseKey: verseKey,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      ayahArabic: ayahArabic,
      ayahTranslation: ayahTranslation,
      ayahPageNumber: ayahPageNumber,
      ayahPosition: ayahPosition,
    );
  }
}