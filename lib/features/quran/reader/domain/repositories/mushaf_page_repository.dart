import '../entities/mushaf_page_row_entity.dart';

abstract interface class MushafPageRepository {
  Future<List<MushafPageRowEntity>> fetchMushafPageData({
    required int pageNumber,
    required String translationColumn,
  });
}
