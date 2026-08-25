import 'package:equatable/equatable.dart';

class FortressSupplicationEntity extends Equatable {
  const FortressSupplicationEntity({
    required this.supplicationId,
    required this.arabicText,
    required this.transcriptionText,
    required this.translationHtml,
    required this.nameAudio,
    required this.countNumber,
  });

  final int supplicationId;
  final String? arabicText;
  final String? transcriptionText;
  final String translationHtml;
  final String? nameAudio;
  final int countNumber;

  bool get hasArabic => arabicText != null;

  bool get hasTranscription => transcriptionText != null;

  bool get hasAudio => nameAudio != null;

  bool get hasRepeatCount => countNumber > 0;

  String? get audioAsset => nameAudio == null ? null : 'assets/audio/$nameAudio.mp3';

  @override
  List<Object?> get props => [
    supplicationId,
    arabicText,
    transcriptionText,
    translationHtml,
    nameAudio,
    countNumber,
  ];
}
