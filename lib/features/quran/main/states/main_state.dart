import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  int _bottomNavigatorIndex = 0;

  int get bottomNavigatorIndex => _bottomNavigatorIndex;

  void setBottomNavigatorIndex(int index) {
    if (_bottomNavigatorIndex == index) return;
    _bottomNavigatorIndex = index;
    notifyListeners();
  }
}
