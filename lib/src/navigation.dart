import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import 'package:opensovereignchess_app/chessboard/src/board_settings.dart';
import 'package:opensovereignchess_app/chessboard/src/widgets/piece.dart';

enum BottomTab {
  home,
  tools,
  settings;

  String get label {
    return switch (this) {
      BottomTab.home => 'Home',
      BottomTab.tools => 'Tools',
      BottomTab.settings => 'Settings',
    };
  }

  IconData get icon {
    return switch (this) {
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
      body: const _TestView(),
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
