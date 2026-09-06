import 'package:flutter/material.dart';

class MainCounterState extends ChangeNotifier {
  int _mainCountValue = 0;

  int get mainCountValue => _mainCountValue;

  void incrementCount() {
    if (_mainCountValue < 1000) {
      _mainCountValue++;
      notifyListeners();
    }
  }

  void decrementCount() {
    if (_mainCountValue > 0) {
      _mainCountValue--;
      notifyListeners();
    }
  }

  void resetCount() {
    _mainCountValue = 0;
    notifyListeners();
  }
}