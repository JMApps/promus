import '../entities/surah_name_entity.dart';

abstract interface class SurahNameRepository {
  Future<List<SurahNameEntity>> fetchAllSurahs();
}