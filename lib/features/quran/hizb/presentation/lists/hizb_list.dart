import 'package:flutter/material.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/hizb_entity.dart';
import '../items/hizb_item.dart';

class HizbList extends StatefulWidget {
  const HizbList({
    super.key,
    required this.hizbs,
  });

  final List<HizbEntity> hizbs;

  @override
  State<HizbList> createState() => _HizbListState();
}

class _HizbListState extends State<HizbList> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: AppPaddings.small,
          margin: AppPaddings.hrMedium,
          alignment: .center,
          decoration: BoxDecoration(
            color: appColors.inversePrimary,
            borderRadius: AppRadius.medium,
          ),
          child: const Text(
            'Хизбы',
            style: AppTextStyles.medium,
            textAlign: .center,
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        const Divider(height: 1),
        Expanded(
          child: Scrollbar(
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              primary: false,
              padding: .zero,
              itemCount: widget.hizbs.length,
              itemBuilder: (context, index) {
                final hizb = widget.hizbs[index];
                return HizbItem(
                  hizb: hizb,
                  index: index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
