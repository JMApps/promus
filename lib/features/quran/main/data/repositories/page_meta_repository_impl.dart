import '../../domain/entities/page_meta_entity.dart';
import '../../domain/repositories/page_meta_repository.dart';
import '../data_sources/page_meta_local_data_source.dart';
import '../mappers/page_meta_mapper.dart';
class PageMetaRepositoryImpl implements PageMetaRepository {

  final PageMetaLocalDataSource _localDataSource;

  PageMetaRepositoryImpl(this._localDataSource);
  @override
  Future<List<PageMetaEntity>> fetchAppPagesMeta() async {
    final metaPages = await _localDataSource.fetchAppPagesMeta();
    return metaPages.map((m) => m.pageMetaToEntity()).toList(growable: false);
  }
}