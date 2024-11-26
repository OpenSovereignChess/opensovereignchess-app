import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'; // For testing purposes
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import 'package:opensovereignchess_app/chessboard/src/board_settings.dart';
import 'package:opensovereignchess_app/chessboard/src/widgets/piece.dart';

import './model/over_the_board/over_the_board_game_controller.dart';

enum NavTab {
  home,
  tools,
  settings;

  String get label {
    return switch (this) {
      NavTab.home => 'Home',
      NavTab.tools => 'Tools',
      NavTab.settings => 'Settings',
    };
  }

  IconData get icon {
    return switch (this) {
      NavTab.home => Icons.home_outlined,
      NavTab.tools => Icons.handyman_outlined,
      NavTab.settings => Icons.settings_outlined,
    };
  }

  IconData get activeIcon {
    return switch (this) {
      NavTab.home => Icons.home,
      NavTab.tools => Icons.handyman,
      NavTab.settings => Icons.settings,
    };
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

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
      body: (_) => const _TestView(),
    );
  }
}

class _TestView extends ConsumerStatefulWidget {
  const _TestView({super.key});

  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends ConsumerState<_TestView> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(overTheBoardGameControllerProvider);
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Chessboard(
            size: math.min(constraints.maxWidth, constraints.maxHeight),
            fen: gameState.position.fen,
            game: GameData(
              validMoves: gameState.legalMoves,
              onMove: _onMove,
            ),
          );
        },
      ),
    );
  }

  void _onMove(NormalMove move, {bool? isDrop}) {
    ref.read(overTheBoardGameControllerProvider.notifier).makeMove(move);
  }
}
