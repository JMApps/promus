import '../../domain/entities/fortress_footnote_entity.dart';
import '../models/fortress_footnote_model.dart';

extension FortressFootnoteMapper on FortressFootnoteModel {
  FortressFootnoteEntity toEntity() {
    return FortressFootnoteEntity(
      footnoteId: footnoteId,
      footnote: footnote,
    );
  }
}
