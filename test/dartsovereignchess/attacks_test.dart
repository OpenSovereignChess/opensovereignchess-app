import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/attacks.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
  test('King attacks', () {
    final attacks = makeSquareSet('''
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . 1 1 1 . . . . . . . . .
. . . . 1 . 1 . . . . . . . . .
. . . . 1 1 1 . . . . . . . . .
. . . . . . . . . . . . . . . .
''');
    expect(kingAttacks(Square.f3), attacks);
  });

  test('Bishop attacks, empty board', () {
    final attacks = makeSquareSet('''
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . 1 . .
. . . . . . . . . . . . 1 . . .
. . . . . . . . . . . 1 . . . .
1 . . . . . . . . . 1 . . . . .
. 1 . . . . . . . 1 . . . . . .
. . 1 . . . . . 1 . . . . . . .
. . . 1 . . . 1 . . . . . . . .
. . . . 1 . 1 . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . 1 . 1 . . . . . . . . .
. . . 1 . . . 1 . . . . . . . .
''');
    //final occupied = SquareSet.fromSquare(Square.f3);
    final occupied = SquareSet.empty;
    final result = bishopAttacks(Square.f3, occupied);
    //print(humanReadableSquareSet(result));
    expect(result, attacks);
  });
}
