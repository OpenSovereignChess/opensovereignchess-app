import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import 'package:opensovereignchess_app/chessboard/src/board_settings.dart';
import 'package:opensovereignchess_app/chessboard/src/widgets/piece.dart';

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

class _TestView extends StatefulWidget {
  const _TestView({super.key});

  @override
  State<_TestView> createState() => _TestViewState();
}

class _TestViewState extends State<_TestView> {
  String _fen =
      'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbpbpbpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp12rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop12npnn/orop12npnr/rqrp12cpcq/rbrp12cpcb/srsnppppwpwpwpwpwpwpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq';
  Pieces _pieces = {};

  @override
  void initState() {
    super.initState();
    _pieces = readFen(_fen);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Chessboard(
            size: math.min(constraints.maxWidth, constraints.maxHeight),
            fen: _fen,
            game: GameData(
              onMove: _onMove,
            ),
          );
        },
      ),
    );
  }

  void _onMove(NormalMove move, {bool? isDrop}) {
    setState(() {
      final piece = _pieces[move.from]!;
      _pieces.remove(move.from);
      _pieces[move.to] = piece;
      _fen = writeFen(_pieces);
    });
  }
}
