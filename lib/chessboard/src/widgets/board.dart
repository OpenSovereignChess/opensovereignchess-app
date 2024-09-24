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
  });

  /// Size of the board in logical pixels.
  final double size;

  /// Settings that control the theme and behavior of the board.
  final ChessboardSettings settings;

  /// FEN string describing the position of the board.
  final String fen;

  @override
  State<Chessboard> createState() => _BoardState();
}

class _BoardState extends State<Chessboard> {
  /// Pieces on the board.
  Pieces pieces = {};

  /// Currently selected square.
  Square? selected;

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

  void _onPointerDown(PointerDownEvent details) {
    if (details.buttons != kPrimaryButton) {
      return;
    }

    final square = widget.offsetSquare(details.localPosition);
    if (square == null) {
      return;
    }

    setState(() {
      selected = square;
    });
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
