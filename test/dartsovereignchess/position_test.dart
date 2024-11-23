import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
  group('SovereignChess', () {
    test('legalMoves', () {
      final pos = SovereignChess.fromSetup(Setup.parseFen(
          '16/16/16/16/16/16/16/16/16/16/16/16/16/16/1wk14/16 1 w - b -'));
      final moves = IMap({
        Square.b2: makeSquareSet('''
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
. . . . . . . . . . . . . . . .
1 1 1 . . . . . . . . . . . . .
1 . 1 . . . . . . . . . . . . .
1 1 1 . . . . . . . . . . . . .
'''),
      });
      final legalMoves = pos.legalMoves;
      expect(legalMoves, equals(moves));
    });
  });

  test('legalMoves, occupied color square', () {
    // We have a black pawn on a red square, so the white pawn on l4
    // cannot move to l5, the other red square.
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/4bp11/16/16/16/16/16/16/16/11wp4/16/16/16 1 w - b -'));
    expect(pos.legalMoves[Square.l4]!.has(Square.l5), false);
  });
}
