import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';
import '../data_sources/surah_local_data_source.dart';
import '../mappers/surah_name_mapper.dart';

class SurahNameRepositoryImpl implements SurahNameRepository {
  final SurahLocalDataSource _localDataSource;

  const SurahNameRepositoryImpl(this._localDataSource);

  @override
  Future<List<SurahNameEntity>> fetchAllSurahs() async {
    final allSurahs = await _localDataSource.fetchAllSurahs();
    return allSurahs.map((m) => m.surahNameToEntity()).toList();
  }
}
