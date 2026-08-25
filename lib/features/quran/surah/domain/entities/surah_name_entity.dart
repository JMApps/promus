import 'package:equatable/equatable.dart';

class SurahNameEntity extends Equatable {
  final int surahNumber;
  final String nameTranscription;
  final String nameTranslation;
  final int revelationOrder;
  final int revelationPlace;
  final int ayahsCount;
  final int bismiLlahPre;
  final int startPageNumber;

  const SurahNameEntity({
    required this.surahNumber,
    required this.nameTranscription,
    required this.nameTranslation,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.bismiLlahPre,
    required this.startPageNumber,
  });

  @override
  List<Object?> get props => [
    surahNumber,
    nameTranscription,
    nameTranslation,
    revelationOrder,
    revelationPlace,
    ayahsCount,
    bismiLlahPre,
    startPageNumber,
  ];
}
