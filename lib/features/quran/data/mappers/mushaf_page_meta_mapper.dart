import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../models/mushaf_page_meta_model.dart';

extension MushafPageMetaMapper on MushafPageMetaModel {
  MushafPageMetaEntity mushafPageMetaToEntity() {
    return MushafPageMetaEntity(
      pageNumber: pageNumber,
      surahNumber: surahNumber,
      juzNumber: juzNumber,
      hizbNumber: hizbNumber,
    );
  }
}
