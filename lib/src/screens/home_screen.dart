import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import '../model/over_the_board/over_the_board_game_controller.dart';
import '../navigation.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeScreen> {
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
              sideToMove: gameState.position.turn,
              validMoves: gameState.legalMoves,
              isCheck: gameState.position.isCheck,
              checkedKingColor: gameState.position.checkedKingColor,
              onMove: _onMove,
              promotionMove: gameState.promotionMove,
              promotionColor: gameState.promotionColor,
              onPromotionSelection: ref
                  .read(overTheBoardGameControllerProvider.notifier)
                  .onPromotionSelection,
            ),
          );
        },
      ),
    );
  }

  void _onMove(NormalMove move, {bool? isDrop, PieceColor? color}) {
    ref
        .read(overTheBoardGameControllerProvider.notifier)
        .makeMove(move, color: color);
  }
}
