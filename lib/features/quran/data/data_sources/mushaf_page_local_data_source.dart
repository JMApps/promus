import '../models/mushaf_page_row_model.dart';

abstract interface class MushafPageLocalDataSource {
  Future<List<MushafPageRowModel>> fetchPageData({
    required int pageNumber,
    required String translationColumn,
  });
}
