import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';

class DatabaseInitState extends ChangeNotifier {
  Future<Database> _dbFuture = DatabaseHelper.instance.db;

  Future<Database> get dbFuture => _dbFuture;

  void retry() {
    _dbFuture = DatabaseHelper.instance.reinstallFromAssets();
    notifyListeners();
  }
}
