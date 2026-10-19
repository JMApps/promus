import '../entities/mushaf_page_meta_entity.dart';

abstract interface class MushafPageMetaRepository {
  Future<List<MushafPageMetaEntity>> fetchMushafPagesMeta();
}
