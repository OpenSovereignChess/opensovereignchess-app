import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
//import 'package:opensovereignchess_app/src/constants.dart';
//import 'package:opensovereignchess_app/src/utils/screen.dart';

import '../model/over_the_board/over_the_board_game_controller.dart';
import '../widgets/defection_dialog.dart';
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

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;

                //final defaultBoardSize = constraints.biggest.shortestSide;
                //final isTablet = isTabletOrLarger(context);
                //final remainingHeight =
                //    constraints.maxHeight - defaultBoardSize;
                //final isSmallScreen =
                //    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                //final boardSize = isTablet || isSmallScreen
                //    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                //    : defaultBoardSize;

                final direction =
                    aspectRatio > 1 ? Axis.horizontal : Axis.vertical;

                return Flex(
                  direction: direction,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Chessboard(
                      size:
                          math.min(constraints.maxWidth, constraints.maxHeight),
                      orientation: Side.player1,
                      fen: gameState.position.fen,
                      game: GameData(
                        sideToMove: gameState.position.turn,
                        validMoves: gameState.legalMoves,
                        isCheck: gameState.position.isCheck,
                        checkedKingColor: gameState.position.checkedKingColor,
                        onMove: (NormalMove move,
                            {bool? isDrop, PieceColor? color}) {
                          ref
                              .read(
                                  overTheBoardGameControllerProvider(initialFen)
                                      .notifier)
                              .makeMove(move, color: color);
                        },
                        promotionMove: gameState.promotionMove,
                        promotionColor: gameState.promotionColor,
                        onPromotionSelection: ref
                            .read(overTheBoardGameControllerProvider(initialFen)
                                .notifier)
                            .onPromotionSelection,
                      ),
                    ),
                    _Menu(
                      initialFen: initialFen,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Menu extends ConsumerWidget {
  const _Menu({
    required this.initialFen,
  });

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(overTheBoardGameControllerProvider(initialFen));

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Spacer(flex: 1),
          _CastleSwitch(initialFen: initialFen),
          TextButton(
            onPressed: gameState.canDefect(gameState.position.turn)
                ? () async {
                    final PieceColor? defectColor = await showDefectionDialog(
                        context, gameState.position.controlledColors);
                    if (defectColor != null) {
                      ref
                          .read(overTheBoardGameControllerProvider(initialFen)
                              .notifier)
                          .defect(defectColor);
                    }
                  }
                : null,
            child: const Text('Defect'),
          ),
          const Spacer(flex: 1),
          TextButton(
            onPressed: () {
              final fen =
                  Uri.encodeComponent(gameState.fen.replaceAll(' ', '_'));
              context.go('/editor?fen=$fen');
            },
            child: const Text('Board Editor'),
          ),
          TextButton(
            onPressed: () async {
              final fen =
                  Uri.encodeComponent(gameState.fen.replaceAll(' ', '_'));
              final url = '/?fen=$fen';
              await Clipboard.setData(
                  ClipboardData(text: 'https://sovchess.web.app$url'));
            },
            child: const Text('Copy URL'),
          ),
        ],
      ),
    );
  }
}

class _CastleSwitch extends ConsumerStatefulWidget {
  const _CastleSwitch({this.initialFen});

  final String? initialFen;

  @override
  ConsumerState<_CastleSwitch> createState() => _CastleSwitchState();
}

class _CastleSwitchState extends ConsumerState<_CastleSwitch> {
  bool _isCastling = false;

  @override
  Widget build(BuildContext context) {
    final gameState =
        ref.watch(overTheBoardGameControllerProvider(widget.initialFen));
    final canCastle = gameState.position.canCastle;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.castle,
                        color: _isCastling
                            ? Theme.of(context).colorScheme.primary
                            : canCastle
                                ? Colors.grey
                                : Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(width: 8),
                    Text(
                      'Castle',
                      style: TextStyle(
                        color:
                            canCastle ? null : Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
                if (!canCastle)
                  Text(
                    'Not available in current position',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
              ],
            ),
            const Spacer(),
            Switch(
              value: _isCastling,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: canCastle
                  ? (bool value) {
                      setState(() {
                        _isCastling = value;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
