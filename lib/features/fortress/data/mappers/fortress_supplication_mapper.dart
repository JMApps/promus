import '../../domain/entities/fortress_supplication_entity.dart';
import '../models/fortress_supplication_model.dart';

extension FortressSupplicationMapper on FortressSupplicationModel {
  FortressSupplicationEntity toEntity() {
    return FortressSupplicationEntity(
      supplicationId: supplicationId,
      arabicText: arabicText,
      transcriptionText: transcriptionText,
      translationHtml: translationHtml,
      nameAudio: nameAudio,
      countNumber: countNumber,
    );
  }
}

extension FortressSupplicationListMapper on List<FortressSupplicationModel> {
  List<FortressSupplicationEntity> toEntities() =>
      map((model) => model.toEntity()).toList(growable: false);
}
