import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
//import 'package:chessboard/chessboard.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';

import '../board_settings.dart';
import '../fen.dart';
import '../models.dart';
import './geometry.dart';
import './highlight.dart';
import './piece.dart';
import './positioned_square.dart';
import './promotion.dart';

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
    required this.orientation,
    required this.fen,
    required this.game,
  });

  /// Size of the board in logical pixels.
  @override
  final double size;

  /// Side by which the board is oriented.
  @override
  final Side orientation;

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
  //Square? _draggedPieceSquare;

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
    final ISet<Square> moveDests = widget.settings.showValidMoves &&
            selected != null &&
            widget.game?.validMoves != null
        ? widget.game?.validMoves[selected!] ?? _emptyValidMoves
        : _emptyValidMoves;
    final checkSquare = widget.game?.isCheck == true ? _getKingSquare() : null;

    final List<Widget> highlightedBackground = [
      SizedBox.square(
        key: const ValueKey('board-background'),
        dimension: widget.size,
        child: colorScheme.background,
      ),
      if (selected != null)
        PositionedSquare(
          key: ValueKey('${selected!.name}-selected'),
          size: widget.size,
          orientation: widget.orientation,
          square: selected!,
          child: SquareHighlight(color: colorScheme.selected),
        ),
      for (final dest in moveDests)
        PositionedSquare(
          key: ValueKey('${dest.name}-dest'),
          size: widget.size,
          orientation: widget.orientation,
          square: dest,
          child: ValidMoveHighlight(
            size: widget.squareSize,
            color: colorScheme.validMoves,
            occupied: pieces.containsKey(dest),
          ),
        ),
      if (checkSquare != null)
        PositionedSquare(
          key: ValueKey('${checkSquare.name}-check'),
          size: widget.size,
          orientation: widget.orientation,
          square: checkSquare,
          child: CheckHighlight(size: widget.squareSize),
        ),
    ];

    final List<Widget> objects = [
      for (final entry in pieces.entries)
        PositionedSquare(
          key: ValueKey('${entry.key.name}-${entry.value}'),
          size: widget.size,
          orientation: widget.orientation,
          square: entry.key,
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
            if (widget.game?.promotionMove != null)
              PromotionSelector(
                pieceAssets: widget.settings.pieceAssets,
                move: widget.game!.promotionMove!,
                size: widget.size,
                orientation: widget.orientation,
                color: widget.game!.promotionColor!,
                onSelect: widget.game!.onPromotionSelection,
                onCancel: () {
                  widget.game!.onPromotionSelection(null);
                },
                roles: widget.game!.promotionRoles,
              )
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

  Square? _getKingSquare() {
    for (final square in pieces.keys) {
      if (pieces[square]!.color == widget.game?.checkedKingColor &&
          pieces[square]!.role == Role.king) {
        return square;
      }
    }
    return null;
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
          //final couldMove = _tryMove(square, drop: true);
          _tryMove(square, drop: true);
        } else {
          shouldDeselect = false;
        }
      }
      _onDragEnd();
      setState(() {
        if (shouldDeselect) {
          selected = null;
        }
        //_draggedPieceSquare = null;
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
        //_draggedPieceSquare = square;
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
    final validDests = widget.game?.validMoves[orig];
    return orig != dest && validDests != null && validDests.contains(dest);
  }

  /// Tries to move the selected piece to the target square.
  ///
  /// Returns true if the move was successful.
  bool _tryMove(Square square, {bool drop = false}) {
    final selectedPiece = selected != null ? pieces[selected] : null;
    if (selectedPiece != null && _canMoveTo(selected!, square)) {
      final move = NormalMove(from: selected!, to: square);
      widget.game?.onMove.call(move, isDrop: drop, color: selectedPiece.color);
      return true;
    }
    return false;
  }
}

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

const ISet<Square> _emptyValidMoves = ISetConst({});
