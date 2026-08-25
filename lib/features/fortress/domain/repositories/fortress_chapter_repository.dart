import '../entities/fortress_chapter_entity.dart';

abstract interface class FortressChapterRepository {
  Future<List<FortressChapterEntity>> fetchAllChapters();
}