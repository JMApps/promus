import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ayahs/states/ayah_flash_state.dart';
import '../lists/reader_page_list.dart';
import '../states/reader_app_bar_state.dart';
import '../widgets/reader_app_bar.dart';

class MushafReaderPage extends StatefulWidget {
  const MushafReaderPage({
    super.key,
    required this.initialPage,
    this.initialVerseKey,
  });

  final int initialPage;
  final String? initialVerseKey;

  @override
  State<MushafReaderPage> createState() => _MushafReaderPageState();
}

class _MushafReaderPageState extends State<MushafReaderPage> {
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
    return ChangeNotifierProvider(
      create: (_) => AyahFlashState(),
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
            initialVerseKey: widget.initialVerseKey,
          ),
        ),
      ),
    );
  }
}
