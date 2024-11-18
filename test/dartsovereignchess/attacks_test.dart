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

  test('Knight attacks', () {
    expect(
      knightAttacks(Square.d4),
      makeSquareSet('''
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
. . 1 . 1 . . . . . . . . . . .
. 1 . . . 1 . . . . . . . . . .
. . . . . . . . . . . . . . . .
. 1 . . . 1 . . . . . . . . . .
. . 1 . 1 . . . . . . . . . . .
. . . . . . . . . . . . . . . .
'''),
    );
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
    final occupied = SquareSet.empty;
    final result = bishopAttacks(Square.f3, occupied);
    expect(result, attacks);
  });

  test('Bishop attacks, occupied board', () {
    final attacks = makeSquareSet('''
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . 1 . . . . .
. 1 . . . . . . . 1 . . . . . .
. . 1 . . . . . 1 . . . . . . .
. . . 1 . . . 1 . . . . . . . .
. . . . 1 . 1 . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . 1 . 1 . . . . . . . . .
. . . 1 . . . . . . . . . . . .
''');
    final occupied =
        SquareSet.fromSquares([Square.d1, Square.g2, Square.b7, Square.k8]);
    final result = bishopAttacks(Square.f3, occupied);
    expect(result, attacks);
  });

  test('Rook attacks, empty board', () {
    final attacks = makeSquareSet('''
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
1 1 1 1 1 1 1 . 1 1 1 1 1 1 1 1
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
''');
    final result = rookAttacks(Square.h9, SquareSet.empty);
    expect(result, attacks);
  });

  test('Rook attacks, occupied board', () {
    final attacks = makeSquareSet('''
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . 1 . 1 1 1 1 1 1 1 .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . 1 . . . . . . . .
. . . . . . . . . . . . . . . .
''');
    final occupied =
        SquareSet.fromSquares([Square.g9, Square.h2, Square.h12, Square.o9]);
    final result = rookAttacks(Square.h9, occupied);
    expect(result, attacks);
  });

  test('Queen attacks', () {
    expect(
      queenAttacks(Square.d4, SquareSet.empty),
      makeSquareSet('''
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . 1 . . . . . . . 1 . . . .
. . . 1 . . . . . . 1 . . . . .
. . . 1 . . . . . 1 . . . . . .
. . . 1 . . . . 1 . . . . . . .
. . . 1 . . . 1 . . . . . . . .
1 . . 1 . . 1 . . . . . . . . .
. 1 . 1 . 1 . . . . . . . . . .
. . 1 1 1 . . . . . . . . . . .
1 1 1 . 1 1 1 1 1 1 1 1 . . . .
. . 1 1 1 . . . . . . . . . . .
. 1 . 1 . 1 . . . . . . . . . .
1 . . 1 . . 1 . . . . . . . . .
'''),
    );
  });
}
