import '../entities/page_meta_entity.dart';

abstract interface class PageMetaRepository {
  Future<List<PageMetaEntity>> fetchAppPagesMeta();
}
