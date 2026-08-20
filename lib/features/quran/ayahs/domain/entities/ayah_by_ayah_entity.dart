import 'package:equatable/equatable.dart';

class AyahByAyahEntity extends Equatable {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;
  final int ayahPageNumber;
  final int ayahPosition;

  const AyahByAyahEntity({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.ayahPageNumber,
    required this.ayahPosition,
  });

  @override
  List<Object?> get props => [
    ayahId,
    verseKey,
    surahNumber,
    ayahNumber,
    ayahArabic,
    ayahTranslation,
    ayahPageNumber,
    ayahPosition,
  ];
}