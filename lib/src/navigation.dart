import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

enum NavTab {
  home,
  boardEditor;
  //settings;

  String get label {
    return switch (this) {
      NavTab.home => 'Home',
      NavTab.boardEditor => 'Board Editor',
      //NavTab.settings => 'Settings',
    };
  }

  IconData get icon {
    return switch (this) {
      NavTab.home => Icons.home_outlined,
      NavTab.boardEditor => Icons.handyman_outlined,
      //NavTab.settings => Icons.settings_outlined,
    };
  }

  IconData get activeIcon {
    return switch (this) {
      NavTab.home => Icons.home,
      NavTab.boardEditor => Icons.handyman,
      //NavTab.settings => Icons.settings,
    };
  }

  String get path {
    return switch (this) {
      NavTab.home => '/',
      NavTab.boardEditor => '/editor',
    };
  }
}

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: <NavigationDestination>[
        for (final tab in NavTab.values)
          NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.activeIcon),
            label: tab.label,
          )
      ],
      onSelectedIndexChange: (int index) {
        for (final tab in NavTab.values) {
          if (tab.index == index) {
            context.go(tab.path);
          }
        }
      },
      body: (_) => body,
    );
  }
}
