import '../models/hizb_model.dart';

abstract interface class HizbLocalDataSource {
  Future<List<HizbModel>> fetchAllHizbs();
}