import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import '../model/over_the_board/over_the_board_game_controller.dart';
import '../navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.initialFen});

  final String? initialFen;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _Body(initialFen),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.initialFen);

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(overTheBoardGameControllerProvider(initialFen));

    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Chessboard(
            size: math.min(constraints.maxWidth, constraints.maxHeight),
            orientation: Side.player1,
            fen: gameState.position.fen,
            game: GameData(
              sideToMove: gameState.position.turn,
              validMoves: gameState.legalMoves,
              isCheck: gameState.position.isCheck,
              checkedKingColor: gameState.position.checkedKingColor,
              onMove: (NormalMove move, {bool? isDrop, PieceColor? color}) {
                ref
                    .read(
                        overTheBoardGameControllerProvider(initialFen).notifier)
                    .makeMove(move, color: color);
              },
              promotionMove: gameState.promotionMove,
              promotionColor: gameState.promotionColor,
              onPromotionSelection: ref
                  .read(overTheBoardGameControllerProvider(initialFen).notifier)
                  .onPromotionSelection,
            ),
          );
        },
      ),
    );
  }
}
