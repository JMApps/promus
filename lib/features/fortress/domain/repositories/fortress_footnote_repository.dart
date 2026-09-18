import '../entities/fortress_footnote_entity.dart';

abstract interface class FortressFootnoteRepository {
  Future<FortressFootnoteEntity> fetchFootnoteById({required int footnoteId});

  Future<List<FortressFootnoteEntity>> fetchFootnotesBySupplication({required int supplicationId});
}
