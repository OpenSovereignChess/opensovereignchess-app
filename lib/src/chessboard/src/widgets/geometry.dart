import 'package:flutter/widgets.dart';
import 'package:opensovereignchess_app/src/dartsovereignchess/dartsovereignchess.dart';

/// A mixin that provides geometry information about the chessboard.
mixin ChessboardGeometry {
  /// Visual size of the board.
  double get size;

  /// Size of a single square on the board.
  double get squareSize => size / 16;

  /// Converts a square to a board offset.
  Offset squareOffset(Square square) {
    final x = square.file;
    final y = 15 - square.rank;
    return Offset(x * squareSize, y * squareSize);
  }

  /// Converts a board offset to a square.
  ///
  /// Returns `null` if the offset is outside the board.
  Square? offsetSquare(Offset offset) {
    final x = (offset.dx / squareSize).floor();
    final y = (offset.dy / squareSize).floor();
    final orientX = x;
    final orientY = 15 - y;
    if (orientX >= 0 && orientX <= 15 && orientY >= 0 && orientY <= 15) {
      return Square.fromCoords(File(orientX), Rank(orientY));
    } else {
      return null;
    }
  }
}
