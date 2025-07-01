import './models.dart';
import './square_set.dart';

/// Gets squares that a pawn on [Square] can move to, given `occupied` squares.
///
/// A pawn can move one square horizontally or vertically toward the center
/// of the board.  The brown lines on the board help guide pawns toward the
/// center.
///
/// A pawn on the first or second ring of the board may move either one or two
/// squares away from the closest edge.  This is true even if the pawn has
/// previously moved.
///
/// Pawns capture diagonally as long as they move toward at least on of the
/// two brown lines (even if they move further away from another brown line).
/// There is no en passant capture.
SquareSet pawnMoves(Square square, SquareSet occupied) {
  final outerRingsFiles = {
    File.a,
    File.b,
    File.o,
    File.p,
  };
  final outerRingsRanks = {
    Rank.first,
    Rank.second,
    Rank.fifteenth,
    Rank.sixteenth,
  };

  switch ((square.file, square.rank)) {
    // NOTE: We're arbitrarily doing two step moves for squares that are close
    // to the corners, but in reality, I don't think this case should ever
    // happen.
    case (int f, int r)
        when outerRingsRanks.contains(r) && !outerRingsFiles.contains(f):
      return _computeTwoSteps(square, _pawnMovesVertical, occupied);
    case (int f, _) when outerRingsFiles.contains(f):
      return _computeTwoSteps(square, _pawnMovesHorizontal, occupied);
    default:
      return _pawnMoves[square].diff(occupied);
  }
}

SquareSet _computeRange(Square square, List<int> deltas) {
  SquareSet range = SquareSet.empty;
  for (final delta in deltas) {
    final sq = square + delta;
    if (0 <= sq &&
        sq < Square.values.length &&
        (square.file - Square(sq).file).abs() <= 2) {
      range = range.withSquare(Square(sq));
    }
  }
  return range;
}

List<T> _tabulate<T>(T Function(Square square) f) {
  final List<T> table = [];
  for (final square in Square.values) {
    table.insert(square, f(square));
  }
  return table;
}

final _pawnMovesVertical = _tabulate(
  (sq) => switch (sq.rank) {
    int r when r < Rank.eighth => _computeRange(sq, [16]),
    int r when r > Rank.ninth => _computeRange(sq, [-16]),
    _ => SquareSet.empty,
  },
);

final _pawnMovesHorizontal = _tabulate(
  (sq) => switch (sq.file) {
    int f when f < File.h => _computeRange(sq, [1]),
    int f when f > File.i => _computeRange(sq, [-1]),
    _ => SquareSet.empty,
  },
);

final _pawnMoves =
    _tabulate((sq) => _pawnMovesVertical[sq] | _pawnMovesHorizontal[sq]);

SquareSet _computeTwoSteps(
    Square square, List<SquareSet> oneStepMoves, SquareSet occupied) {
  final oneStep = oneStepMoves[square].diff(occupied);
  final oneStepSquare = oneStep.lsb();
  final twoSteps =
      oneStepSquare != null ? oneStepMoves[oneStepSquare] : SquareSet.empty;
  return (oneStep | twoSteps | _pawnMoves[square]).diff(occupied);
}
