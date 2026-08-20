import '../models/juz_model.dart';

abstract interface class JuzLocalDataSource {
  Future<List<JuzModel>> fetchAllJuzs();
}