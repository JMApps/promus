import '../../domain/entities/juz_entity.dart';
import '../models/juz_model.dart';

extension JuzMapper on JuzModel {
  JuzEntity juzToEntity() {
    return JuzEntity(
      juzNumber: juzNumber,
      versesCount: versesCount,
      firstVerseKey: firstVerseKey,
      lastVerseKey: lastVerseKey,
      startPageNumber: startPageNumber,
    );
  }
}
