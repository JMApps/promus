import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../bookmarks/presentation/states/bookmarks_state.dart';
import '../../../main/states/page_number_state.dart';
import '../items/read_item.dart';
import '../states/mushaf_page_font_state.dart';
import '../states/mushaf_page_load_state.dart';
import '../states/mushaf_page_row_state.dart';

class ReaderPageList extends StatefulWidget {
  const ReaderPageList({
    super.key,
    required this.pageNumber,
    required this.pageController,
  });

  final int pageNumber;
  final PageController pageController;

  @override
  State<ReaderPageList> createState() => _ReaderPageListState();
}

class _ReaderPageListState extends State<ReaderPageList>
    with WidgetsBindingObserver {
  late final PageNumberState _pageNumberState;
  late final MushafPageRowState _mushafPageRowState;
  late final MushafPageFontState _mushafPageFontState;
  late final BookmarksState _bookmarksState;

  late int _currentPage;

  @override
  void initState() {
    super.initState();

    _pageNumberState = context.read<PageNumberState>();
    _mushafPageRowState = context.read<MushafPageRowState>();
    _mushafPageFontState = context.read<MushafPageFontState>();
    _bookmarksState = context.read<BookmarksState>();

    WidgetsBinding.instance.addObserver(this);

    _currentPage = widget.pageNumber;
    _pageNumberState.setPageNumber(_currentPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mushafPageRowState.loadWindow(_currentPage);
      _mushafPageFontState.loadWindow(_currentPage);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveLastOpenedPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveLastOpenedPage();
    super.dispose();
  }

  void _saveLastOpenedPage() {
    _bookmarksState.addLastOpenedPage(_pageNumberState.pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      reverse: true,
      physics: const ClampingScrollPhysics(),
      itemCount: 604,
      onPageChanged: (index) {
        final page = index + 1;

        if (_currentPage == page) return;

        _currentPage = page;

        _pageNumberState.setPageNumber(page);
        _mushafPageRowState.loadWindow(page);
        _mushafPageFontState.loadWindow(page);
      },
      itemBuilder: (context, index) {
        final page = index + 1;

        return Selector<MushafPageRowState, MushafPageLoadState>(
          selector: (_, state) => state.getPageState(page),
          builder: (context, state, _) {
            if (state.error != null) {
              return Padding(
                padding: AppPaddings.medium,
                child: Center(
                  child: Text('${state.error}'),
                ),
              );
            }

            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final rows = state.data!;

            return ReadItem(
              pageNumber: page,
              rows: rows,
            );
          },
        );
      },
    );
  }
}
