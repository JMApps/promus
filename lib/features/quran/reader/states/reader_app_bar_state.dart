import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReaderAppBarState extends ChangeNotifier {
  bool _showAppBar = true;

  bool get showAppBar => _showAppBar;

  Future<void> toggleShowAppBar() async {
    _showAppBar = !_showAppBar;
    unawaited(_showAppBar ? _showSystemUi() : _hideSystemUi());
    notifyListeners();
  }

  Future<void> restoreSystemUI() async {
    await _showSystemUi();
  }

  Future<void> _showSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    _showAppBar = true;
  }

  Future<void> _hideSystemUi() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _showSystemUi();
    super.dispose();
  }
}