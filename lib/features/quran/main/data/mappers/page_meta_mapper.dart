import '../../domain/entities/page_meta_entity.dart';
import '../models/page_meta_model.dart';

extension PageMetaMapper on PageMetaModel {
  PageMetaEntity pageMetaToEntity() {
    return PageMetaEntity(
      pageNumber: pageNumber,
      surahNumber: surahNumber,
      juzNumber: juzNumber,
      hizbNumber: hizbNumber,
    );
  }
}
