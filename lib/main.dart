import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/main/pages/root_page.dart';
import 'features/main/state/main_state.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainState(),
        ),
      ],
      child: const RootPage(),
    ),
  );
}
