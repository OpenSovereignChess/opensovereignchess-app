import 'package:flutter/widgets.dart';

import './square_set.dart';

/// A board represented by several square sets for each piece.
@immutable
class Board {
  const Board({
    required this.occupied,
  });

  /// All occupied squares.
  final SquareSet occupied;

  /// Standard chess starting position.
  //static const standard = Board(
  //  occupied: SquareSet(),
  //);

  /// Empty board.
  static const empty = Board(
    occupied: SquareSet.empty,
  );

  /// Parse the board part of a FEN string and returns a Board.
  ///
  /// Throws a [FenException] if the provided FEN string is not valid.
  factory Board.parseFen(String boardFen) {
    Board board = Board.empty;
    return board;
  }
}
