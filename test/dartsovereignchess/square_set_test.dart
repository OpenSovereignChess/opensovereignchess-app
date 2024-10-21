import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/square_set.dart';

void main() {
  test('SquareSet.has returns true if the SquareSet contains the given square',
      () {
    final squareSet = SquareSet(0, 0, 0, 0, 0, 0, 0, 1);
    expect(squareSet.has(Square.a1), true);

    final squareSet2 = SquareSet(0, 0, 0, 0, 0, 0, 0x1, 0);
    expect(squareSet2.has(Square.a3), true);
  });

  test(
      'SquareSet.withSquare returns a new SquareSet with the given square added',
      () {
    final squareSet = SquareSet.empty;
    final result = squareSet.withSquare(Square.a1);
    //print(humanReadableSquareSet(result));
    expect(result.has(Square.a1), true);
  });
}
