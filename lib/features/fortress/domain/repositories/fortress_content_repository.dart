import '../entities/fortress_content_entity.dart';

abstract interface class FortressContentRepository {
  Future<List<FortressBookContentEntity>> fetchAllBookContent();
}
