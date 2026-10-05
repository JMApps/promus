import 'package:equatable/equatable.dart';

class GlyphEntity extends Equatable {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final int wordNumber;
  final String glyph;
  final String word;
  final String? arabicAyah;
  final String? translation;

  const GlyphEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordNumber,
    required this.glyph,
    required this.word,
    this.arabicAyah,
    this.translation,
  });

  @override
  List<Object?> get props => [
    id,
    surahNumber,
    ayahNumber,
    wordNumber,
    glyph,
    word,
    arabicAyah,
    translation,
  ];
}
