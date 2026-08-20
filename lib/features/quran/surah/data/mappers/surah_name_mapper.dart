import '../../domain/entities/surah_name_entity.dart';
import '../models/surah_name_model.dart';

extension SurahNameMapper on SurahNameModel {
  SurahNameEntity surahNameToEntity() {
    return SurahNameEntity(
      surahNumber: surahNumber,
      nameTranscriptionRu: nameTranscriptionRu,
      nameTranslationRu: nameTranslationRu,
      revelationOrder: revelationOrder,
      revelationPlace: revelationPlace,
      ayahsCount: ayahsCount,
      bismiLlahPre: bismiLlahPre,
      startPageNumber: startPageNumber,
    );
  }
}
