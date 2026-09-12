import '../entities/fortress_supplication_entity.dart';

abstract interface class FortressSupplicationRepository {
  Future<List<FortressSupplicationEntity>> fetchSupplicationsByChapter({required int chapterId});

  Future<FortressSupplicationEntity> fetchSupplicationById({required int supplicationId});
}
