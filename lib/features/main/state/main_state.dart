import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  int _mainNavigationIndex = 0;

  int get mainNavigationIndex => _mainNavigationIndex;

  void changeNavigationIndex(int index) {
    if (_mainNavigationIndex != index) {
      _mainNavigationIndex = index;
      notifyListeners();
    }
  }

  void resetToHome() => changeNavigationIndex(0);
}
