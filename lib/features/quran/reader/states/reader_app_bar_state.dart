import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReaderAppBarState extends ChangeNotifier {
  bool _showAppBar = true;

  bool get showAppBar => _showAppBar;

  void toggleShowAppBar() {
    _showAppBar = !_showAppBar;
    _showAppBar ? _showSystemUi() : _hideSystemUi();
    notifyListeners();
  }

  void restoreSystemUI() {
    _showSystemUi();
  }

  void _showSystemUi() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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

  void _hideSystemUi() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _showSystemUi();
    super.dispose();
  }
}