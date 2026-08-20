import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bookmarks/presentation/states/bookmarks_state.dart';
import '../../../main/states/page_number_state.dart';
import '../lists/reader_page_list.dart';
import '../states/reader_app_bar_state.dart';
import '../widgets/reader_app_bar.dart';

class ReaderPage extends StatefulWidget {
  final int initialPage;

  const ReaderPage({super.key, required this.initialPage});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late final ReaderAppBarState _appBarState;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage - 1);
    _appBarState = context.read<ReaderAppBarState>();
  }

  @override
  void dispose() {
    _appBarState.restoreSystemUI();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            context.read<BookmarksState>().addLastOpenedPage(
              context.read<PageNumberState>().pageNumber,
            );
          },
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ReaderAppBar(pageController: _pageController),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => context.read<ReaderAppBarState>().toggleShowAppBar(),
              child: ReaderPageList(
                pageController: _pageController,
                pageNumber: widget.initialPage,
              ),
            ),
          ),
        );
      },
    );
  }
}
