import './models.dart';
import './square_set.dart';

/// Gets squares attacked or defended by a king on [Square].
SquareSet kingAttacks(Square square) {
  return _kingAttacks[square];
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

final _kingAttacks =
    _tabulate((sq) => _computeRange(sq, [-17, -16, -15, -1, 1, 15, 16, 17]));
