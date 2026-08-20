import '../entities/hizb_entity.dart';

abstract interface class HizbRepository {
  Future<List<HizbEntity>> fetchAllHizbs();
}