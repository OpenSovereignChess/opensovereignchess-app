import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/src/constants.dart';
import 'package:opensovereignchess_app/src/navigation.dart';
import 'package:opensovereignchess_app/src/model/board_editor/board_editor_controller.dart';
import 'package:opensovereignchess_app/src/utils/screen.dart';

class BoardEditorScreen extends StatelessWidget {
  const BoardEditorScreen({super.key, this.initialFen});

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
    final boardEditorState =
        ref.watch(boardEditorControllerProvider(initialFen));

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;

                final defaultBoardSize = constraints.biggest.shortestSide;
                final isTablet = isTabletOrLarger(context);
                final remainingHeight =
                    constraints.maxHeight - defaultBoardSize;
                final isSmallScreen =
                    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                    : defaultBoardSize;

                final direction =
                    aspectRatio > 1 ? Axis.horizontal : Axis.vertical;

                return Flex(
                  direction: direction,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _BoardEditor(
                      boardSize,
                      initialFen: initialFen,
                      orientation: boardEditorState.orientation,
                      isTablet: isTablet,
                      // unlockView is safe because chessground will never modify the pieces
                      pieces: boardEditorState.pieces.unlockView,
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

class _BoardEditor extends ConsumerWidget {
  const _BoardEditor(
    this.boardSize, {
    required this.initialFen,
    required this.isTablet,
    required this.orientation,
    required this.pieces,
  });

  final String? initialFen;
  final double boardSize;
  final bool isTablet;
  final Side orientation;
  final Pieces pieces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider(initialFen));
    // TODO: Don't need now
    //final boardPrefs = ref.watch(boardPreferencesProvider);

    return ChessboardEditor(
      size: boardSize,
      pieces: pieces,
      orientation: orientation,
      //settings: boardPrefs.toBoardSettings().copyWith(
      //  borderRadius: isTablet ? const BorderRadius.all(Radius.circular(4.0)) : BorderRadius.zero,
      //  boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
      //),
      pointerMode: editorState.editorPointerMode,
      onDiscardedPiece: (Square square) => ref
          .read(boardEditorControllerProvider(initialFen).notifier)
          .discardPiece(square),
      onDroppedPiece: (Square? origin, Square dest, Piece piece) => ref
          .read(boardEditorControllerProvider(initialFen).notifier)
          .movePiece(origin, dest, piece),
      onEditedSquare: (Square square) => ref
          .read(boardEditorControllerProvider(initialFen).notifier)
          .editSquare(square),
    );
  }
}

const Widget verticalSpacer = SizedBox(height: 16);

class _Menu extends ConsumerWidget {
  const _Menu({
    required this.initialFen,
  });

  final String? initialFen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider(initialFen));

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          verticalSpacer,
          _PieceMenu(),
          verticalSpacer,
          TextButton(
            onPressed: () {
              final fen =
                  Uri.encodeComponent(editorState.fen.replaceAll(' ', '_'));
              context.go('/?fen=$fen');
            },
            child: const Text('Analysis Board'),
          ),
        ],
      ),
    );
  }
}

class _PieceMenu extends ConsumerWidget {
  const _PieceMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('Piece Menu');
  }
}
