import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../bookmarks/presentation/pages/bookmarks_page.dart';
import '../../juz/presentation/pages/juz_page.dart';
import '../../settings/pages/app_settings_page.dart';
import '../../surah/presentation/pages/surah_name_page.dart';
import '../states/main_state.dart';

class MushafPage extends StatefulWidget {
  const MushafPage({super.key});

  @override
  State<MushafPage> createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  late final ScrollController _surahScrollController;
  late final ScrollController _juzScrollController;

  late final List<Widget> _mainPages;

  @override
  void initState() {
    super.initState();

    _surahScrollController = ScrollController();
    _juzScrollController = ScrollController();

    _mainPages = [
      SurahNamePage(scrollController: _surahScrollController),
      const BookmarksPage(),
      JuzPage(scrollController: _juzScrollController),
      const AppSettingsPage(),
    ];
  }

  @override
  void dispose() {
    _surahScrollController.dispose();
    _juzScrollController.dispose();
    super.dispose();
  }

  void _scrollCurrentTabToTop(int index) {
    final controller = switch (index) {
      0 => _surahScrollController,
      2 => _juzScrollController,
      _ => null,
    };

    if (controller == null || !controller.hasClients) return;

    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentNavigatorIndex = context.select<MainState, int>(
      (s) => s.bottomNavigatorIndex,
    );
    final appColors = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentNavigatorIndex,
        children: _mainPages,
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [
                appColors.primary.withAlpha(0),
                appColors.primary.withAlpha(15),
                appColors.primary.withAlpha(35),
                appColors.primary.withAlpha(75),
                appColors.primary.withAlpha(95),
              ],
            ),
          ),
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            margin: AppPaddings.withoutTopMedium,
            shape: AppShapes.large,
            child: ClipRRect(
              borderRadius: AppRadius.large,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.5, sigmaY: 12.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.surface.withValues(alpha: 0.65),
                    borderRadius: AppRadius.large,
                  ),
                  child: SalomonBottomBar(
                    itemShape: AppShapes.medium,
                    selectedItemColor: appColors.primary,
                    unselectedItemColor: appColors.onSurface.withAlpha(185),
                    items: [
                      SalomonBottomBarItem(
                        icon: const Icon(Icons.line_style_rounded),
                        title: const Text('Суры'),
                      ),
                      SalomonBottomBarItem(
                        icon: const Icon(Icons.bookmark_rounded),
                        title: const Text('Избранное'),
                      ),
                      SalomonBottomBarItem(
                        icon: const Icon(Icons.circle_rounded),
                        title: const Text('Джузы'),
                      ),
                      SalomonBottomBarItem(
                        icon: const Icon(Icons.settings_rounded),
                        title: const Text('Настройки'),
                      ),
                    ],
                    currentIndex: currentNavigatorIndex,
                    onTap: (int index) {
                      if (currentNavigatorIndex != index) {
                        context.read<MainState>().setBottomNavigatorIndex(
                          index,
                        );
                      } else {
                        _scrollCurrentTabToTop(index);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
