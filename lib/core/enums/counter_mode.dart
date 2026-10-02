import '../constants/app_constants.dart';

enum CounterMode {
  free(
    initialValue: 0,
    countsDown: false,
    storageKey: AppConstants.keyFreeCounterValue,
  ),
  count33(
    initialValue: 33,
    countsDown: true,
    storageKey: AppConstants.key33CounterValue,
  ),
  count100(
    initialValue: 100,
    countsDown: true,
    storageKey: AppConstants.key100CounterValue,
  ),
  count1000(
    initialValue: 1000,
    countsDown: true,
    storageKey: AppConstants.key1000CounterValue,
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