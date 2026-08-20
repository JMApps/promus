import '../../../../../core/database/constants/column_names.dart';

class SurahNameModel {
  final int surahNumber;
  final String nameTranscriptionRu;
  final String nameTranslationRu;
  final int revelationOrder;
  final int revelationPlace;
  final int ayahsCount;
  final int bismiLlahPre;
  final int startPageNumber;

  const SurahNameModel({
    required this.surahNumber,
    required this.nameTranscriptionRu,
    required this.nameTranslationRu,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.bismiLlahPre,
    required this.startPageNumber,
  });

  factory SurahNameModel.fromMap(Map<String, Object?> map) {
    return SurahNameModel(
      surahNumber: map[ColumnNames.surahNumber] as int,
      nameTranscriptionRu: map[ColumnNames.nameTranscription] as String,
      nameTranslationRu: map[ColumnNames.nameTranslation] as String,
      revelationOrder: map[ColumnNames.revelationOrder] as int,
      revelationPlace: map[ColumnNames.revelationPlace] as int,
      ayahsCount: map[ColumnNames.ayahsCount] as int,
      bismiLlahPre: map[ColumnNames.bismiLlahPre] as int,
      startPageNumber: map[ColumnNames.startPageNumber] as int,
    );
  }
}
