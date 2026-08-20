import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../search/presentation/delegates/search_ayahs_delegate.dart';
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
    final isLoading = context.select<SurahNameState, bool>((s) => s.isLoading);
    final error = context.select<SurahNameState, Object?>((s) => s.error);
    final surahs = context.select<SurahNameState, List<SurahNameEntity>>(
      (s) => s.surahs,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Мусхаф',
          style: AppTextStyles.medium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchAyahsDelegate(
                  searchField: 'Поиск аятов',
                ),
              );
            },
            tooltip: 'Поиск аятов',
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: switch ((isLoading, error)) {
        (true, _) => const Center(child: CircularProgressIndicator.adaptive()),
        (_, final e?) => Padding(
          padding: AppPaddings.medium,
          child: Center(child: Text('$e')),
        ),
        _ => SurahNameList(
          scrollController: scrollController,
          surahs: surahs,
        ),
      },
    );
  }
}
