import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
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

  test('legalMoves, occupied color square', () {
    // We have a black pawn on a red square, so the white pawn on l4
    // cannot move to l5, the other red square.
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/4bp11/16/16/16/16/16/16/16/11wp4/16/16/16 1 w - b -'));
    expect(pos.legalMoves[Square.l4]!.has(Square.l5), false);
  });

  test('play, move onto colored squares', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/3bp12/16/16/16/16/16/16/16/11wp4/16/16/16 1 w - b -'));
    expect(pos.p1Controlled.contains(PieceColor.red), false);
    final move = NormalMove(from: Square.l4, to: Square.l5);
    final pos1 = pos.play(move);
    expect(pos1.board.white.has(Square.l5), true);
    expect(pos1.p1Controlled.contains(PieceColor.red), true);
  });

  test('play, move off of colored squares', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/3bp12/16/16/16/16/16/16/11wp4/16/16/16/16 1 w r b -'));
    expect(pos.p1Controlled.contains(PieceColor.red), true);
    final move = NormalMove(from: Square.l5, to: Square.l6);
    final pos1 = pos.play(move);
    expect(pos1.board.white.has(Square.l6), true);
    expect(pos1.p1Controlled.contains(PieceColor.red), false);
  });

  test('legalMoves, can capture a piece on colored square', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/4bpwq10/16/16/16/16/16/16/16/16/16/16/16 1 w - b -'));
    expect(pos.legalMoves[Square.f12]!.has(Square.e12), true);
  });
}
