import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../states/mushaf_page_load_state.dart';
import '../../states/mushaf_page_number_state.dart';
import '../../states/mushaf_page_state.dart';
import '../../surah/states/surah_bookmark_state.dart';
import '../items/read_item.dart';

class ReaderPageList extends StatefulWidget {
  const ReaderPageList({
    super.key,
    required this.pageNumber,
    required this.pageController,
    this.initialVerseKey,
  });

  final int pageNumber;
  final PageController pageController;
  final String? initialVerseKey;

  @override
  State<ReaderPageList> createState() => _ReaderPageListState();
}

class _ReaderPageListState extends State<ReaderPageList> with WidgetsBindingObserver {
  late final MushafPageNumberState _pageNumberState;
  late final MushafPageState _mushafPageState;
  late final SurahBookmarkState _bookmarkState;

  late int _currentPage;

  String? _jumpVerseKey;

  @override
  void initState() {
    super.initState();
    _jumpVerseKey = widget.initialVerseKey;

    _pageNumberState = context.read<MushafPageNumberState>();
    _mushafPageState = context.read<MushafPageState>();
    _bookmarkState = context.read<SurahBookmarkState>();

    WidgetsBinding.instance.addObserver(this);

    _currentPage = widget.pageNumber;
    _pageNumberState.setPageNumber(_currentPage);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mushafPageState.loadWindow(_currentPage);
      _bookmarkState.addLastOpenedPage(_currentPage);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      reverse: true,
      itemCount: AppConstants.totalMushafPageCount,
      onPageChanged: (index) {

        _jumpVerseKey = null;

        final page = index + 1;
        if (_currentPage == page) return;
        _currentPage = page;

        _pageNumberState.setPageNumber(page);
        _mushafPageState.loadWindow(page);
        _bookmarkState.addLastOpenedPage(page);
      },
      itemBuilder: (context, index) {
        final page = index + 1;
        return Selector<MushafPageState, MushafPageLoadState>(
          selector: (_, mushafPageState) => mushafPageState.getPageState(page),
          builder: (context, mushafPageState, _) {
            if (mushafPageState.error != null) {
              return Padding(
                padding: AppPaddings.medium,
                child: Center(child: Text('${mushafPageState.error}')),
              );
            }
            if (!mushafPageState.loaded) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return ReadItem(
              rows: mushafPageState.data!,
              scrollToVerseKey: page == widget.pageNumber ? _jumpVerseKey : null,
            );
          },
        );
      },
    );
  }
}
