import '../constants/app_constant_keys.dart';

enum CounterMode {
  free(
    initialValue: 0,
    countsDown: false,
    storageKey: AppConstantKeys.keyFreeCounterValue,
  ),
  count33(
    initialValue: 33,
    countsDown: true,
    storageKey: AppConstantKeys.key33CounterValue,
  ),
  count100(
    initialValue: 100,
    countsDown: true,
    storageKey: AppConstantKeys.key100CounterValue,
  ),
  count1000(
    initialValue: 1000,
    countsDown: true,
    storageKey: AppConstantKeys.key1000CounterValue,
  );

  const CounterMode({
    required this.initialValue,
    required this.countsDown,
    required this.storageKey,
  });

  final int initialValue;
  final bool countsDown;
  final String storageKey;
}