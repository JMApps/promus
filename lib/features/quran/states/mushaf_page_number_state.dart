import 'package:flutter/material.dart';

class MushafPageNumberState extends ChangeNotifier {
  int _pageNumber = 1;

  int get pageNumber => _pageNumber;

  void setPageNumber(int pageNumber) {
    if (_pageNumber == pageNumber) return;
    _pageNumber = pageNumber;
    notifyListeners();
  }
}