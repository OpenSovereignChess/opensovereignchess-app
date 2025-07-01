import 'package:test/test.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';
import 'package:dartsovereignchess/src/attacks.dart';
import 'package:dartsovereignchess/src/debug.dart';

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

  test('Pawn attacks', () {
    expect(
      pawnAttacks(Square.d4),
      SquareSet.fromSquares([Square.c5, Square.e5, Square.e3]),
    );
    expect(
      pawnAttacks(Square.l4),
      SquareSet.fromSquares([Square.k5, Square.m5, Square.k3]),
    );
    expect(
      pawnAttacks(Square.d13),
      SquareSet.fromSquares([Square.c12, Square.e12, Square.e14]),
    );
    expect(
      pawnAttacks(Square.l13),
      SquareSet.fromSquares([Square.k12, Square.m12, Square.k14]),
    );

    // On first ring
    expect(
      pawnAttacks(Square.d1),
      SquareSet.fromSquares([Square.c2, Square.e2]),
    );
    expect(
      pawnAttacks(Square.d16),
      SquareSet.fromSquares([Square.c15, Square.e15]),
    );
    expect(
      pawnAttacks(Square.a4),
      SquareSet.fromSquares([Square.b5, Square.b3]),
    );
    expect(
      pawnAttacks(Square.p13),
      SquareSet.fromSquares([Square.o12, Square.o14]),
    );
    expect(
      pawnAttacks(Square.l16),
      SquareSet.fromSquares([Square.k15, Square.m15]),
    );

    // On edge of quadrant
    expect(
      pawnAttacks(Square.h2),
      SquareSet.fromSquares([Square.g3, Square.i3]),
    );
    expect(
      pawnAttacks(Square.i4),
      SquareSet.fromSquares([Square.h5, Square.j5]),
    );
    expect(
      pawnAttacks(Square.d9),
      SquareSet.fromSquares([Square.e10, Square.e8]),
    );
    expect(
      pawnAttacks(Square.i15),
      SquareSet.fromSquares([Square.h14, Square.j14]),
    );
    expect(
      pawnAttacks(Square.l9),
      SquareSet.fromSquares([Square.k8, Square.k10]),
    );
    expect(
      pawnAttacks(Square.l8),
      SquareSet.fromSquares([Square.k7, Square.k9]),
    );
  });
}
