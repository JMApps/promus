import '../../../../core/database/constants/column_names.dart';

class AyahByAyahModel {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;
  final int ayahPageNumber;
  final int ayahPosition;

  const AyahByAyahModel({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.ayahPageNumber,
    required this.ayahPosition,
  });

  factory AyahByAyahModel.fromMap(Map<String, Object?> map) {
    return AyahByAyahModel(
      ayahId: map[ColumnNames.ayahId] as int,
      verseKey: map[ColumnNames.verseKey] as String,
      surahNumber: map[ColumnNames.surahNumber] as int,
      ayahNumber: map[ColumnNames.ayahNumber] as int,
      ayahArabic: map[ColumnNames.ayahArabic] as String,
      ayahTranslation: map[ColumnNames.ayahTranslation] as String,
      ayahPageNumber: map[ColumnNames.ayahPageNumber] as int,
      ayahPosition: map[ColumnNames.ayahPosition] as int,
    );
  }
}
