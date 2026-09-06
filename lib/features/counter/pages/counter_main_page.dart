import 'package:flutter/material.dart';
import 'package:promus/core/constants/font_families.dart';
import 'package:promus/features/counter/state/main_counter_state.dart';
import 'package:provider/provider.dart';

class CounterMainPage extends StatelessWidget {
  const CounterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final countState = context.read<MainCounterState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счетчик'),
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 3,
            child: Text(
              context.watch<MainCounterState>().mainCountValue.toString(),
              style: TextStyle(
                fontFamily: FontFamilies.ptSans,
                fontSize: 95.0,
                color: appColors.primary,
              ),
              textAlign: .center,
            ),
          ),
          Expanded(
            flex: 9,
            child: IconButton(
              onPressed: () {
                countState.incrementCount();
              },
              icon: const Icon(
                Icons.circle,
                size: 300.0,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              countState.resetCount();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
