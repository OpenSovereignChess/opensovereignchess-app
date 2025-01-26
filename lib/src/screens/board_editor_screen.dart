import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
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
                      boardSize,
                      initialFen: initialFen,
                      isTablet: isTablet,
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
  const _Menu(
    this.boardSize, {
    required this.initialFen,
    required this.isTablet,
  });

  final String? initialFen;

  final double boardSize;

  final bool isTablet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(boardEditorControllerProvider(initialFen));

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          verticalSpacer,
          ...PieceColor.values.map((color) => _PieceMenu(
                boardSize,
                initialFen: initialFen,
                color: color,
                isTablet: isTablet,
              )),
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

class _PieceMenu extends ConsumerStatefulWidget {
  const _PieceMenu(
    this.boardSize, {
    required this.initialFen,
    required this.color,
    required this.isTablet,
  });

  final String? initialFen;

  final double boardSize;

  final PieceColor color;

  final bool isTablet;

  @override
  ConsumerState<_PieceMenu> createState() => _PieceMenuState();
}

final _assets = const ChessboardSettings().pieceAssets;
final _enabledColor = Colors.green[400]!;

class _PieceMenuState extends ConsumerState<_PieceMenu> {
  @override
  Widget build(BuildContext context) {
    //final boardPrefs = ref.watch(boardPreferencesProvider);
    final editorController = boardEditorControllerProvider(widget.initialFen);
    final editorState = ref.watch(editorController);

    final squareSize = widget.boardSize / 16;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: widget.isTablet
            ? const BorderRadius.all(Radius.circular(4.0))
            : BorderRadius.zero,
        boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
      ),
      child: ColoredBox(
        color: Theme.of(context).disabledColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                width: squareSize,
                height: squareSize,
                child: ColoredBox(
                  key: Key('drag-button-${widget.color.name}'),
                  color: editorState.editorPointerMode == EditorPointerMode.drag
                      ? _enabledColor
                      : Colors.transparent,
                  child: GestureDetector(
                    onTap: () => ref
                        .read(editorController.notifier)
                        .updateMode(EditorPointerMode.drag),
                    child:
                        Icon(CupertinoIcons.hand_draw, size: 0.9 * squareSize),
                  ),
                ),
              ),
            ),
            ...Role.values.map((role) {
              final piece = Piece(role: role, color: widget.color);
              final pieceWidget = PieceWidget(
                piece: piece,
                size: squareSize,
                //pieceAssets: boardPrefs.pieceSet.assets,
                pieceAssets: _assets,
              );

              return Expanded(
                child: ColoredBox(
                  key: Key(
                      'piece-button-${piece.color.name}-${piece.role.name}'),
                  color: ref
                              .read(boardEditorControllerProvider(
                                  widget.initialFen))
                              .activePieceOnEdit ==
                          piece
                      ? _enabledColor
                      : Colors.transparent,
                  child: GestureDetector(
                    child: Draggable(
                      data: Piece(role: role, color: widget.color),
                      feedback: PieceDragFeedback(
                        piece: piece,
                        squareSize: squareSize,
                        //pieceAssets: boardPrefs.pieceSet.assets,
                        pieceAssets: _assets,
                      ),
                      child: pieceWidget,
                      onDragEnd: (_) => ref
                          .read(editorController.notifier)
                          .updateMode(EditorPointerMode.drag),
                    ),
                    onTap: () => ref
                        .read(editorController.notifier)
                        .updateMode(EditorPointerMode.edit, piece),
                  ),
                ),
              );
            }),
            Expanded(
              child: SizedBox(
                key: Key('delete-button-${widget.color.name}'),
                width: squareSize,
                height: squareSize,
                child: ColoredBox(
                  color: editorState.deletePiecesActive
                      ? _enabledColor
                      : Colors.transparent,
                  child: GestureDetector(
                    onTap: () => {
                      ref
                          .read(editorController.notifier)
                          .updateMode(EditorPointerMode.edit, null),
                    },
                    child: Icon(CupertinoIcons.delete, size: 0.8 * squareSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
