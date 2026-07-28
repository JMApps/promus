import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shapes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(),
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
              filter: ImageFilter.blur(sigmaX: 10.5, sigmaY: 10.5),
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.surface,
                  borderRadius: AppRadius.large,
                ),
                child: SalomonBottomBar(
                  itemShape: AppShapes.medium,
                  selectedItemColor: appColors.primary,
                  unselectedItemColor: appColors.onSurface.withAlpha(185),
                  items: [
                    SalomonBottomBarItem(
                      icon: Image.asset(
                        'assets/icons/home.png',
                        height: 25,
                        width: 25,
                        color: appColors.primary,
                      ),
                      title: const Text(AppStrings.titleHome),
                    ),
                    SalomonBottomBarItem(
                      icon: Image.asset(
                        'assets/icons/book.png',
                        height: 25,
                        width: 25,
                        color: appColors.primary,
                      ),
                      title: const Text(AppStrings.titleMushaf),
                    ),
                    SalomonBottomBarItem(
                      icon: Image.asset(
                        'assets/icons/library.png',
                        height: 25,
                        width: 25,
                        color: appColors.primary,
                      ),
                      title: const Text(AppStrings.titleLibrary),
                    ),
                    SalomonBottomBarItem(
                      icon: Image.asset(
                        'assets/icons/setting.png',
                        height: 25,
                        width: 25,
                        color: appColors.primary,
                      ),
                      title: const Text(AppStrings.titleSettings),
                    ),
                  ],
                  currentIndex: 0,
                  onTap: (int index) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
