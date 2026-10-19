import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../states/mushaf_page_number_state.dart';
import '../items/read_item.dart';

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

class _ReaderPageListState extends State<ReaderPageList> with WidgetsBindingObserver {
  late final MushafPageNumberState _pageNumberState;

  late int _currentPage;

  @override
  void initState() {
    super.initState();

    _pageNumberState = context.read<MushafPageNumberState>();

    WidgetsBinding.instance.addObserver(this);

    _currentPage = widget.pageNumber;
    _pageNumberState.setPageNumber(_currentPage);
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
      physics: const ClampingScrollPhysics(),
      itemCount: AppConstants.totalMushafPageCount,
      onPageChanged: (index) {
        final page = index + 1;

        if (_currentPage == page) return;
        _currentPage = page;
        _pageNumberState.setPageNumber(page);
      },
      itemBuilder: (context, index) {
        final page = index + 1;

        return ReadItem(
          pageNumber: page,
          rows: const [],
        );
      },
    );
  }
}
