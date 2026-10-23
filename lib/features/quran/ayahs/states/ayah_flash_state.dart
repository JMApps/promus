import 'dart:async';

import 'package:flutter/foundation.dart';

class AyahFlashState extends ChangeNotifier {
  AyahFlashState({this.hold = const Duration(milliseconds: 1350)});

  final Duration hold;

  bool _isActive = false;
  Timer? _timer;

  bool get isActive => _isActive;

  void flash() {
    _timer?.cancel();

    _isActive = true;
    notifyListeners();

    _timer = Timer(hold, () {
      _isActive = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}