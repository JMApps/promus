import '../../domain/entities/fortress_content_entity.dart';
import '../models/fortress_book_content_model.dart';

extension FortressBookContentMapper on FortressBookContentModel {
  FortressBookContentEntity toEntity() {
    return FortressBookContentEntity(
      bookContentId: bookContentId,
      bookContentTitle: bookContentTitle,
      bookContent: bookContent,
    );
  }
}

extension FortressBookContentListMapper on List<FortressBookContentModel> {
  List<FortressBookContentEntity> toEntities() =>
      map((model) => model.toEntity()).toList(growable: false);
}
