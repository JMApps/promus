import 'package:flutter/material.dart';

class PageNumberState extends ChangeNotifier {
  int _pageNumber = 0;

  int get pageNumber => _pageNumber;

  void setPageNumber(int pageNumber) {
    if (_pageNumber == pageNumber) return;
    _pageNumber = pageNumber;
    notifyListeners();
  }
}