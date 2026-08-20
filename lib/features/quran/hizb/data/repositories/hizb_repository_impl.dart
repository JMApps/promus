import '../../domain/entities/hizb_entity.dart';
import '../../domain/repositories/hizb_repository.dart';
import '../data_sources/hizb_local_data_source.dart';
import '../mappers/hizb_mapper.dart';

class HizbRepositoryImpl implements HizbRepository {
  final HizbLocalDataSource _localDataSource;

  const HizbRepositoryImpl(this._localDataSource);

  @override
  Future<List<HizbEntity>> fetchAllHizbs() async {
    final allHizbs = await _localDataSource.fetchAllHizbs();
    return allHizbs.map((m) => m.hizbToEntity()).toList();
  }
}
