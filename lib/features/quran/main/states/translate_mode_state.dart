import 'package:flutter/material.dart';

class TranslateModeState extends ChangeNotifier {
  bool _translateMode = false;

  bool get translateMode => _translateMode;

  void toggleTranslateMode() {
    _translateMode = !_translateMode;
    notifyListeners();
  }
}