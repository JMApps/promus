import '../../../../core/database/constants/column_names.dart';

class FortressSupplicationModel {
  final int supplicationId;
  final String? arabicText;
  final String? transcriptionText;
  final String translationHtml;
  final String? nameAudio;
  final int countNumber;

  const FortressSupplicationModel({
    required this.supplicationId,
    required this.arabicText,
    required this.transcriptionText,
    required this.translationHtml,
    required this.nameAudio,
    required this.countNumber,
  });

  factory FortressSupplicationModel.fromMap(Map<String, Object?> map) {
    return FortressSupplicationModel(
      supplicationId: map[ColumnNames.supplicationId] as int,
      arabicText: map[ColumnNames.arabicText] as String?,
      transcriptionText: map[ColumnNames.transcriptionText] as String?,
      translationHtml: map[ColumnNames.translationText] as String,
      nameAudio: map[ColumnNames.nameAudio] as String?,
      countNumber: map[ColumnNames.countNumber] as int,
    );
  }
}
