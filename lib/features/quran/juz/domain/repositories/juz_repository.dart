import '../entities/juz_entity.dart';

abstract interface class JuzRepository {
  Future<List<JuzEntity>> fetchAllJuzs();
}