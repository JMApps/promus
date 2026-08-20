import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../main/states/page_meta_state.dart';
import '../items/favorite_page_item.dart';
import '../states/bookmarks_state.dart';

class FavoritePagesList extends StatefulWidget {
  const FavoritePagesList({super.key});

  @override
  State<FavoritePagesList> createState() => _FavoritePagesListState();
}

class _FavoritePagesListState extends State<FavoritePagesList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + AppSpacing.medium * 2;

    return Selector2<BookmarksState, PageMetaState, ({bool loading, Object? error, List pageMetas})>(
      selector: (_, bookmarksState, pageMetaState) => (
      loading: pageMetaState.isLoading,
      error: pageMetaState.error,
      pageMetas: pageMetaState.resolvePages(bookmarksState.favoritePageIds),
      ),
      builder: (context, state, _) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state.error case final e?) {
          return Center(
            child: Padding(
              padding: AppPaddings.medium,
              child: Text('$e', textAlign: TextAlign.center),
            ),
          );
        }

        if (state.pageMetas.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppPaddings.medium,
              child: Text(
                'Список пуст',
                style: AppTextStyles.medium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Scrollbar(
          controller: _controller,
          child: ListView.builder(
            controller: _controller,
            padding: EdgeInsets.only(bottom: bottomHeight),
            itemCount: state.pageMetas.length,
            itemBuilder: (context, index) {
              final pageMetaModel = state.pageMetas[index];

              return FavoritePageItem(
                pageMetaModel: pageMetaModel,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}