import '../../domain/entities/mushaf_page_row_entity.dart';
import '../../domain/repositories/mushaf_page_repository.dart';
import '../data_source/mushaf_page_local_data_source.dart';
import '../mappers/mushaf_page_mapper.dart';

class MushafPageRepositoryImpl implements MushafPageRepository {
  final MushafPageLocalDataSource _localDataSource;

  const MushafPageRepositoryImpl(this._localDataSource);

  @override
  Future<List<MushafPageRowEntity>> fetchMushafPageData({required int pageNumber, required String translationColumn}) async {
    final mushafPageDataByPageNumber = await _localDataSource.fetchPageData(pageNumber: pageNumber, translationColumn: translationColumn);
    return mushafPageDataByPageNumber.map((m) => m.mushafPageRowToEntity()).toList();
  }
}