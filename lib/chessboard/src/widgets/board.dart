import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import '../board_settings.dart';
import 'geometry.dart';
import 'highlight.dart';
import 'piece.dart';
import 'positioned_square.dart';

/// Number of logical pixels that have to be dragged before a drag starts.
const double _kDragDistanceThreshold = 3.0;

/// A Sovereign Chess board widget.
///
/// This widget can be used to display a static board or a full interactive board.
class Chessboard extends StatefulWidget with ChessboardGeometry {
  /// Creates a new chessboard widget with interactive pieces.
  ///
  /// Provide a [game] state to enable interaction with the board.
  /// The [fen] string should be updated when the position changes.
  const Chessboard({
    super.key,
    required this.size,
    this.settings = const ChessboardSettings(),
    required this.fen,
    required this.game,
  });

  /// Size of the board in logical pixels.
  final double size;

  /// Settings that control the theme and behavior of the board.
  final ChessboardSettings settings;

  /// FEN string describing the position of the board.
  final String fen;

  /// Game state of the board.
  ///
  /// If `null`, the board cannot be interacted with.
  final GameData? game;

  @override
  State<Chessboard> createState() => _BoardState();
}

class _BoardState extends State<Chessboard> {
  /// Pieces on the board.
  Pieces pieces = {};

  /// Currently selected square.
  Square? selected;

  /// Whether the selected piece should be deselected on the next tap up event.
  ///
  /// This is used to prevent the deselection of a piece when the user drags it,
  /// but to allow the deselection when the user taps on the selected piece.
  bool _shouldDeselectOnTapUp = false;

  /// Avatar for the piece that is currently being dragged.
  _DragAvatar? _dragAvatar;

  /// Once a piece is dragged, holds the square id of the piece.
  Square? _draggedPieceSquare;

  /// Current pointer down event.
  ///
  /// This field is reset to null when the pointer is released (up or cancel).
  ///
  /// This is used to track board gestures, the pointer that started the drag,
  /// and to prevent other pointers from starting a drag while a piece is being
  /// dragged.
  ///
  /// Other simultaneous pointer events are ignored and will cancel the current
  /// gesture.
  PointerDownEvent? _currentPointerDownEvent;

  /// Current render box during drag.
  RenderBox? _renderBox;

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.settings.colorScheme;

    final List<Widget> highlightedBackground = [
      SizedBox.square(
        key: const ValueKey('board-background'),
        dimension: widget.size,
        child: colorScheme.background,
      ),
      for (final entry in _coloredSquares.entries)
        PositionedSquare(
          key: ValueKey('${entry.key.name}-${entry.value}'),
          size: widget.size,
          square: entry.key,
          child: SquareHighlight(
            color: entry.value,
          ),
        ),
      if (selected != null)
        PositionedSquare(
          key: ValueKey('${selected!.name}-selected'),
          size: widget.size,
          square: selected!,
          child: SquareHighlight(color: colorScheme.selected),
        ),
    ];

    final List<Widget> objects = [
      for (final entry in pieces.entries)
        PositionedSquare(
          key: ValueKey('${entry.key.name}-${entry.value}'),
          size: widget.size,
          square: entry.key,
          //child: _TestPiece(entry.value),
          child: PieceWidget(
            piece: entry.value,
            size: widget.squareSize,
            pieceAssets: widget.settings.pieceAssets,
          ),
        ),
    ];

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: SizedBox.square(
        dimension: widget.size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...highlightedBackground,
            ...objects,
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pieces = readFen(widget.fen);
  }

  @override
  void dispose() {
    super.dispose();
    _dragAvatar?.cancel();
  }

  @override
  void didUpdateWidget(Chessboard oldBoard) {
    super.didUpdateWidget(oldBoard);
    if (oldBoard.fen == widget.fen) {
      // As long as the fen is the same as before let's keep animations
      return;
    }

    final newPieces = readFen(widget.fen);

    pieces = newPieces;
  }

  /// Returns the position of the square target during drag as a global offset.
  Offset? _squareTargetGlobalOffset(Offset localPosition, RenderBox box) {
    final square = widget.offsetSquare(localPosition);
    if (square == null) {
      return null;
    }
    final localOffset = widget.squareOffset(square);
    final tmpOffset = box.localToGlobal(localOffset);
    return Offset(
      tmpOffset.dx - widget.squareSize / 2,
      tmpOffset.dy - widget.squareSize / 2,
    );
  }

  void _onPointerDown(PointerDownEvent details) {
    if (details.buttons != kPrimaryButton) {
      return;
    }

    final square = widget.offsetSquare(details.localPosition);
    if (square == null) {
      return;
    }

    final Piece? piece = pieces[square];

    // From here on, we only allow 1 pointer to interact with the board.
    // Other pointers will cancel any current gesture.
    if (_currentPointerDownEvent != null) {
      _cancelGesture();
      return;
    }

    // Keep a reference to the current pointer down event to handle simultaneous
    // pointer events.
    _currentPointerDownEvent = details;

    // A piece was selected and the user taps on a different square:
    // - try to move the piece to the target square
    // - if the move was not possible but there is a movable piece under the
    // target square, select it
    if (selected != null && square != selected) {
      final couldMove = _tryMove(square);
      if (!couldMove && piece != null) {
        setState(() {
          selected = square;
        });
      } else {
        setState(() {
          selected = null;
        });
      }
    }
    // The selected piece is touched again:
    // - deselect the piece on the next tap up event (as we don't want to deselect
    // the piece when the user drags it)
    else if (selected == square) {
      _shouldDeselectOnTapUp = true;
    }
    // No piece was selected yet and a movable piece is touched:
    // - select the piece
    else if (piece != null) {
      setState(() {
        selected = square;
      });
    }
    // Pointer down on empty square:
    // - unselect piece
    else {
      setState(() {
        selected = null;
      });
    }
  }

  void _onPointerMove(PointerMoveEvent details) {
    if (details.buttons != kPrimaryButton) {
      return;
    }

    if (_currentPointerDownEvent == null ||
        _currentPointerDownEvent!.pointer != details.pointer) {
      return;
    }

    final distance =
        (details.position - _currentPointerDownEvent!.position).distance;
    if (_dragAvatar == null && distance > _kDragDistanceThreshold) {
      _onDragStart(_currentPointerDownEvent!);
    }

    _dragAvatar?.update(details);
    _dragAvatar?.updateSquareTarget(
      _squareTargetGlobalOffset(details.localPosition, _renderBox!),
    );
  }

  void _onPointerUp(PointerUpEvent details) {
    if (_currentPointerDownEvent == null ||
        _currentPointerDownEvent!.pointer != details.pointer) {
      return;
    }

    final square = widget.offsetSquare(details.localPosition);

    // Handle pointer up while dragging a piece
    if (_dragAvatar != null) {
      bool shouldDeselect = true;

      if (square != null) {
        if (square != selected) {
          final couldMove = _tryMove(square, drop: true);
        } else {
          shouldDeselect = false;
        }
      }
      _onDragEnd();
      setState(() {
        if (shouldDeselect) {
          selected = null;
        }
        _draggedPieceSquare = null;
      });
    }
    // Handle pointer up while not dragging a piece
    else if (selected != null) {
      if (square == selected && _shouldDeselectOnTapUp) {
        _shouldDeselectOnTapUp = false;
        setState(() {
          selected = null;
        });
      }
    }

    _shouldDeselectOnTapUp = false;
    _currentPointerDownEvent = null;
  }

  void _onPointerCancel(PointerCancelEvent details) {
    if (_currentPointerDownEvent == null ||
        _currentPointerDownEvent!.pointer != details.pointer) {
      return;
    }

    _onDragEnd();
    setState(() {
      //_draggedPieceSquare = null;
    });
    _currentPointerDownEvent = null;
  }

  void _onDragStart(PointerEvent origin) {
    final square = widget.offsetSquare(origin.localPosition);
    final piece = square != null ? pieces[square] : null;
    final feedbackSize = widget.squareSize * widget.settings.dragFeedbackScale;
    if (square != null && piece != null) {
      setState(() {
        _draggedPieceSquare = square;
      });
      _renderBox ??= context.findRenderObject()! as RenderBox;

      final dragFeedbackOffsetY = widget.settings.dragFeedbackOffset.dy;

      _dragAvatar = _DragAvatar(
        overlayState: Overlay.of(context, debugRequiredFor: widget),
        initialPosition: origin.position,
        initialTargetPosition:
            _squareTargetGlobalOffset(origin.localPosition, _renderBox!),
        squareTargetFeedback: Container(
          width: widget.squareSize * 2,
          height: widget.squareSize * 2,
          decoration: const BoxDecoration(
            color: Color(0x33000000),
            shape: BoxShape.circle,
          ),
        ),
        pieceFeedback: Transform.translate(
          offset: Offset(
            ((widget.settings.dragFeedbackOffset.dx - 1) * feedbackSize) / 2,
            ((dragFeedbackOffsetY - 1) * feedbackSize) / 2,
          ),
          child: PieceWidget(
            piece: piece,
            size: feedbackSize,
            pieceAssets: widget.settings.pieceAssets,
          ),
        ),
      );
    }
  }

  void _onDragEnd() {
    _dragAvatar?.end();
    _dragAvatar = null;
    _renderBox = null;
  }

  /// Cancels the current gesture and stops current selection/drag.
  void _cancelGesture() {
    setState(() {
      selected = null;
    });
    _currentPointerDownEvent = null;
  }

  /// Whether the piece is allowed to be moved to the target square.
  bool _canMoveTo(Square orig, Square dest) {
    return true;
  }

  /// Tries to move the selected piece to the target square.
  ///
  /// Returns true if the move was successful.
  bool _tryMove(Square square, {bool drop = false}) {
    final selectedPiece = selected != null ? pieces[selected] : null;
    if (selectedPiece != null && _canMoveTo(selected!, square)) {
      final move = NormalMove(from: selected!, to: square);
      widget.game?.onMove.call(move, isDrop: drop);
      return true;
    }
    return false;
  }
}

// Temp definition of piece colors while we test them out.
// Tol's color palette - discrete rainbow
const _renderColorsForPieces = {
  PieceColor.white: const Color(0xFFFFFFFF),
  PieceColor.ash: const Color(0xFFCAACCB),
  PieceColor.slate: const Color(0xFF777777),
  PieceColor.black: const Color(0xFF000000),
  // NOTE: Used pink from IBM color palette as there was no pink in Tol's.
  PieceColor.pink: const Color(0xFFFFAFD2),
  PieceColor.red: const Color(0xFFDC050C),
  PieceColor.orange: const Color(0xFFF4A736),
  PieceColor.yellow: const Color(0xFFF7F056),
  PieceColor.green: const Color(0xFF4EB265),
  PieceColor.cyan: const Color(0xFF7BAFDE),
  PieceColor.navy: const Color(0xFF1965B0),
  PieceColor.violet: const Color(0xFF882E72),
};

Widget _TestPiece(Piece piece) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: _renderColorsForPieces[piece.color],
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('${piece.role.letter}'),
    ),
  );
}

const _coloredSquares = {
  Square.e5: Color(0xCC1965B0),
  Square.l12: Color(0xCC1965B0),
  Square.l5: Color(0xCCDC050C),
  Square.e12: Color(0xCCDC050C),
  Square.f6: Color(0xCC4EB265),
  Square.k11: Color(0xCC4EB265),
  Square.h6: Color(0xCC882E72),
  Square.i11: Color(0xCC882E72),
  Square.i6: Color(0xCCFFAFD2),
  Square.h11: Color(0xCCFFAFD2),
  Square.k6: Color(0xCCF7F056),
  Square.f11: Color(0xCCF7F056),
  Square.g7: Color(0xCCCAACCB),
  Square.j10: Color(0xCCCAACCB),
  Square.j7: Color(0xCC777777),
  Square.g10: Color(0xCC777777),
  Square.f8: Color(0xCC7BAFDE),
  Square.k9: Color(0xCC7BAFDE),
  Square.h8: Color(0xCC000000),
  Square.i9: Color(0xCC000000),
  Square.i8: Color(0xCCFFFFFF),
  Square.h9: Color(0xCCFFFFFF),
  Square.k8: Color(0xCCF4A736),
  Square.f9: Color(0xCCF4A736),
};

// For the logic behind this see:
// https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/widgets/drag_target.dart#L805
// and:
// https://github.com/flutter/flutter/blob/ee4e09cce01d6f2d7f4baebd247fde02e5008851/packages/flutter/lib/src/widgets/overlay.dart#L58
class _DragAvatar {
  final Widget pieceFeedback;
  final Widget squareTargetFeedback;
  final OverlayState overlayState;
  Offset _position;
  Offset? _squareTargetPosition;
  late final OverlayEntry _pieceEntry;
  late final OverlayEntry _squareTargetEntry;

  _DragAvatar({
    required this.overlayState,
    required Offset initialPosition,
    Offset? initialTargetPosition,
    required this.pieceFeedback,
    required this.squareTargetFeedback,
  })  : _position = initialPosition,
        _squareTargetPosition = initialTargetPosition {
    _pieceEntry = OverlayEntry(builder: _buildPieceFeedback);
    _squareTargetEntry = OverlayEntry(builder: _buildSquareTargetFeedback);
    overlayState.insert(_squareTargetEntry);
    overlayState.insert(_pieceEntry);
    _updateDrag();
  }

  void update(PointerEvent details) {
    _position += details.delta;
    _updateDrag();
  }

  void updateSquareTarget(Offset? squareTargetOffset) {
    if (_squareTargetPosition != squareTargetOffset) {
      _squareTargetPosition = squareTargetOffset;
      _squareTargetEntry.markNeedsBuild();
    }
  }

  void end() {
    finishDrag();
  }

  void cancel() {
    finishDrag();
  }

  void _updateDrag() {
    _pieceEntry.markNeedsBuild();
  }

  void finishDrag() {
    _pieceEntry.remove();
    _squareTargetEntry.remove();
  }

  Widget _buildPieceFeedback(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: IgnorePointer(
        child: pieceFeedback,
      ),
    );
  }

  Widget _buildSquareTargetFeedback(BuildContext context) {
    if (_squareTargetPosition != null) {
      return Positioned(
        left: _squareTargetPosition!.dx,
        top: _squareTargetPosition!.dy,
        child: IgnorePointer(
          child: squareTargetFeedback,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
