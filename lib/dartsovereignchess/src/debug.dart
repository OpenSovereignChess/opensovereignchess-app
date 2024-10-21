import './models.dart';
import './square_set.dart';

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
