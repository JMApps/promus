import '../models/surah_name_model.dart';

abstract interface class SurahLocalDataSource {
  Future<List<SurahNameModel>> fetchAllSurahs();
}