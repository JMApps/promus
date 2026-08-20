import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';
import '../data_sources/juz_local_data_source.dart';
import '../mappers/juz_mapper.dart';

class JuzRepositoryImpl implements JuzRepository {
  final JuzLocalDataSource _localDataSource;

  const JuzRepositoryImpl(this._localDataSource);

  @override
  Future<List<JuzEntity>> fetchAllJuzs() async {
    final allJuzs = await _localDataSource.fetchAllJuzs();
    return allJuzs.map((m) => m.juzToEntity()).toList();
  }
}
