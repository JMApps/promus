import '../entities/mushaf_page_entity.dart';

abstract interface class MushafPageRepository {
  Future<List<MushafPageEntity>> fetchMushafPageData({
    required int pageNumber,
    required String translationColumn,
  });
}
