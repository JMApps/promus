import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../lists/surah_name_list.dart';
import '../states/surah_name_state.dart';

class SurahNamePage extends StatelessWidget {
  const SurahNamePage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final mqPadding = MediaQuery.of(context).padding;
    final appColors = Theme.of(context).colorScheme;
    final isLoading = context.select<SurahNameState, bool>((s) => s.isLoading);
    final error = context.select<SurahNameState, Object?>((s) => s.error);
    final surahs = context.select<SurahNameState, List<SurahNameEntity>>((s) => s.surahs);
    return Scaffold(
      body: switch ((isLoading, error)) {
        (true, _) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        (_, final e?) => Padding(
          padding: AppPaddings.medium,
          child: Center(
            child: Text(
              '$e',
              style: TextStyle(
                color: appColors.error,
              ),
            ),
          ),
        ),
        _ => RawScrollbar(
          controller: scrollController,
          padding: .only(
            top: mqPadding.top + kToolbarHeight,
            bottom: mqPadding.bottom,
          ),
          thickness: 2.75,
          thumbColor: appColors.primary.withAlpha(125),
          radius: const .circular(AppSpacing.medium),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                centerTitle: false,
                title: const Text(AppStrings.titleMushaf),
                actions: [
                  IconButton.filledTonal(
                    onPressed: () {},
                    tooltip: AppStrings.searchAyahs,
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              SliverPadding(
                padding: const .only(bottom: kBottomNavigationBarHeight + AppSpacing.medium * 1.5),
                sliver: SurahNameList(surahs: surahs),
              ),
            ],
          ),
        ),
      },
    );
  }
}
