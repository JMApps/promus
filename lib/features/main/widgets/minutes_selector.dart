import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class MinutesSelector extends StatelessWidget {
  const MinutesSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return ActionChip(
      visualDensity: .compact,
      label: Text('$value ${AppStrings.minShort.toLowerCase()}'),
      side: BorderSide(
        color: enabled ? appColors.primary : appColors.surfaceContainer,
      ),
      onPressed: enabled ? () async {
        final result = await showMinutesPicker(context, initial: value);
        if (result != null) onChanged(result);
      } : null,
    );
  }
}

Future<int?> showMinutesPicker(BuildContext context, {required int initial, int max = 30}) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (_) => _MinutesPickerSheet(initial: initial, max: max),
  );
}

class _MinutesPickerSheet extends StatefulWidget {
  const _MinutesPickerSheet({required this.initial, required this.max});

  final int initial;
  final int max;

  @override
  State<_MinutesPickerSheet> createState() => _MinutesPickerSheetState();
}

class _MinutesPickerSheetState extends State<_MinutesPickerSheet> {
  late final FixedExtentScrollController _controller;
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    _controller = FixedExtentScrollController(initialItem: widget.initial - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: .min,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  AppStrings.cancel,
                  style: AppTextStyles.medium,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _selected),
                child: const Text(
                  AppStrings.ready,
                  style: AppTextStyles.medium,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: _controller,
              onSelectedItemChanged: (i) => _selected = i + 1,
              children: [
                for (var m = 1; m <= widget.max; m++)
                  Center(
                    child: Text(
                      '$m ${AppStrings.minShort.toLowerCase()}',
                      style: AppTextStyles.medium,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
