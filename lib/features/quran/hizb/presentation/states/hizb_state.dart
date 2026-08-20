import 'package:flutter/material.dart';

import '../../domain/entities/hizb_entity.dart';
import '../../domain/repositories/hizb_repository.dart';

class HizbState extends ChangeNotifier {
  final HizbRepository _hizbRepository;

  HizbState(this._hizbRepository) {
    _loadAllHizbs();
  }

  List<HizbEntity> _hizbs = const [];

  bool _isLoading = false;
  Object? _error;

  List<HizbEntity> get hizbs => _hizbs;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  Future<void> _loadAllHizbs() async {
    _isLoading = true;

    try {
      _hizbs = await _hizbRepository.fetchAllHizbs();
      _error = null;
    } catch (e, s) {
      _error = e;
      debugPrint('$e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
