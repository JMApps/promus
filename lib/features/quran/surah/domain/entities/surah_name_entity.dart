import 'package:equatable/equatable.dart';

class SurahNameEntity extends Equatable {
  final int surahNumber;
  final String nameTranscriptionRu;
  final String nameTranslationRu;
  final int revelationOrder;
  final int revelationPlace;
  final int ayahsCount;
  final int bismiLlahPre;
  final int startPageNumber;

  const SurahNameEntity({
    required this.surahNumber,
    required this.nameTranscriptionRu,
    required this.nameTranslationRu,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.bismiLlahPre,
    required this.startPageNumber,
  });

  @override
  List<Object?> get props => [
    surahNumber,
    nameTranscriptionRu,
    nameTranslationRu,
    revelationOrder,
    revelationPlace,
    ayahsCount,
    bismiLlahPre,
    startPageNumber,
  ];
}
