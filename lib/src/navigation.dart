import 'package:flutter/material.dart';

enum BottomTab {
  home,
  tools,
  settings;

  String get label {
    return switch(this) {
      BottomTab.home => 'Home',
      BottomTab.tools => 'Tools',
      BottomTab.settings => 'Settings',
    };
  }

  IconData get icon {
    return switch(this) {
      BottomTab.home => Icons.home_outlined,
      BottomTab.tools => Icons.handyman_outlined,
      BottomTab.settings => Icons.settings_outlined,
    };
  }
}

class BottomNavScaffold extends StatelessWidget {
  const BottomNavScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('HELLO WORLD'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          for (final tab in BottomTab.values)
            NavigationDestination(
              icon: Icon(tab.icon),
              label: tab.label,
            )
        ],
      ),
    );
  }
}
