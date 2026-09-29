import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/main_counter_state.dart';

class MainCounterButton extends StatelessWidget {
  const MainCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return IconButton(
      onPressed: () {
        context.read<MainCounterState>().incrementCount();
      },
      icon: Icon(
        Icons.fingerprint_rounded,
        size: mediaQuery.orientation == Orientation.portrait ? mediaQuery.size.width * 0.85 : mediaQuery.size.width * 0.25,
      ),
    );
  }
}
