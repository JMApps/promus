import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/icon_paths.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shapes.dart';
import '../../prayer/presentation/pages/main_prayer_page.dart';
import '../state/main_state.dart';
import '../widgets/main_navigation_icon.dart';
import '../widgets/main_navigation_label.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> _mainPages;

  @override
  void initState() {
    super.initState();
    _mainPages = <Widget>[
      const MainPrayerPage(),
      const MainPrayerPage(),
      const MainPrayerPage(),
      const MainPrayerPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final currentNavigatorIndex = context.select<MainState, int>((s) => s.mainNavigationIndex);
    return Scaffold(
      body: _mainPages[currentNavigatorIndex],
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
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
                  color: appColors.primaryContainer.withAlpha(055),
                  borderRadius: AppRadius.large,
                ),
                child: SalomonBottomBar(
                  itemShape: AppShapes.medium,
                  selectedItemColor: appColors.primary,
                  unselectedItemColor: appColors.onSurface.withAlpha(185),
                  items: [
                    SalomonBottomBarItem(
                      icon: const MainNavigationIcon(iconPath: IconPaths.iconPathHome),
                      title: const MainNavigationLabel(label: AppStrings.titleHome),
                    ),
                    SalomonBottomBarItem(
                      icon: const MainNavigationIcon(iconPath: IconPaths.iconPathMushaf),
                      title: const MainNavigationLabel(label: AppStrings.titleMushaf),
                    ),
                    SalomonBottomBarItem(
                      icon: const MainNavigationIcon(iconPath: IconPaths.iconPathLibrary),
                      title: const MainNavigationLabel(label: AppStrings.titleLibrary),
                    ),
                    SalomonBottomBarItem(
                      icon: const MainNavigationIcon(iconPath: IconPaths.iconPathSetting),
                      title: const MainNavigationLabel(label: AppStrings.titleSettings),
                    ),
                  ],
                  currentIndex: currentNavigatorIndex,
                  onTap: (int index) {
                    context.read<MainState>().changeNavigationIndex(index);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
