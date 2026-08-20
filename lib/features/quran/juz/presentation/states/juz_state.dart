import 'package:flutter/material.dart';

import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';

class JuzState extends ChangeNotifier {
  final JuzRepository _juzRepository;

  JuzState(this._juzRepository) {
    _loadAllJuzs();
  }

  List<JuzEntity> _juzs = const [];

  bool _isLoading = false;
  Object? _error;

  List<JuzEntity> get juzs => _juzs;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  Future<void> _loadAllJuzs() async {
    _isLoading = true;

    try {
      _juzs = await _juzRepository.fetchAllJuzs();
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
