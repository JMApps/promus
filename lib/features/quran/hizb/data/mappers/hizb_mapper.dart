import '../../domain/entities/hizb_entity.dart';
import '../models/hizb_model.dart';

extension HizbMapper on HizbModel {
  HizbEntity hizbToEntity() {
    return HizbEntity(
      hizbNumber: hizbNumber,
      versesCount: versesCount,
      firstVerseKey: firstVerseKey,
      lastVerseKey: lastVerseKey,
      startPageNumber: startPageNumber,
    );
  }
}
