import '../models/page_meta_model.dart';

abstract interface class PageMetaLocalDataSource {
  Future<List<PageMetaModel>> fetchAppPagesMeta();
}
