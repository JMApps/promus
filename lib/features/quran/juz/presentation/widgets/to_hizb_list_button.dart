import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../hizb/domain/entities/hizb_entity.dart';
import '../../../hizb/presentation/lists/hizb_list.dart';
import '../../../hizb/presentation/states/hizb_state.dart';

class ToHizbsPageButton extends StatelessWidget {
  const ToHizbsPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final isLoading = context.select<HizbState, bool>((s) => s.isLoading);
    final allHizbs = context.select<HizbState, List<HizbEntity>>(
      (s) => s.hizbs,
    );
    return isLoading
        ? const CircularProgressIndicator.adaptive()
        : IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (context) {
                  return HizbList(hizbs: allHizbs);
                },
              );
            },
            tooltip: 'Хизбы',
            color: appColors.secondary,
            icon: const Icon(Icons.pie_chart),
          );
  }
}
