import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../data_sources/ayah_by_ayah_local_data_source.dart';
import '../mappers/ayah_by_ayah_mapper.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  final AyahByAyahLocalDataSource _dataSource;

  const AyahByAyahRepositoryImpl(this._dataSource);

  @override
  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) async {
    final searchResultAyahs = await _dataSource.searchAyahs(query: query);
    return searchResultAyahs.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<List<AyahByAyahEntity>> fetchAyahsByIds({required List<int> ayahIds}) async {
    final ayahsByIds = await _dataSource.fetchAyahsByIds(ayahIds: ayahIds);
    return ayahsByIds.map((m) => m.toEntity()).toList(growable: false);
  }
}