import './models.dart';
import './square_set.dart';

/// Takes a string a returns a SquareSet.  Useful for debugging/testing purposes.
SquareSet makeSquareSet(String rep) {
  SquareSet ret = SquareSet.empty;
  final table = rep
      .split('\n')
      .where((l) => l.isNotEmpty)
      .map((r) => r.split(' '))
      .toList()
      .reversed
      .toList();
  for (int y = Rank.values.last; y >= 0; y--) {
    for (int x = 0; x < File.values.length; x++) {
      final repSq = table[y][x];
      if (repSq == '1') {
        ret = ret.withSquare(Square(x + y * File.values.length));
      }
    }
  }
  return ret;
}

/// Prints the square set as a human readable string format
String humanReadableSquareSet(SquareSet sq) {
  final buffer = StringBuffer();
  for (int r = 15; r >= 0; r--) {
    for (int f = 0; f < 16; f++) {
      final square = Square(f + r * 16);
      buffer.write(sq.has(square) ? '1' : '.');
      buffer.write(f < 15 ? ' ' : '\n');
    }
  }
  return buffer.toString();
}
