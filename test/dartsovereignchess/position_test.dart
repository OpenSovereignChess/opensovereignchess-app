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

  test('legalMoves, can capture a piece on colored square', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/9bq6/16/16/9wq6/16/16/16/16/16/16 1 w - b -'));
    expect(pos.legalMoves[Square.j7]!.has(Square.j10), true);
  });

  test('legalMoves, cannot move onto a square of its own color', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bq7/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16 2 w - b -'));
    expect(pos.legalMoves[Square.i16]!.has(Square.i9), false);
  });

  test('legalMoves, king cannot move into check', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/br15/8wk7 1 w - b -'));
    expect(pos.legalMoves[Square.i1]!.has(Square.i2), false);
  });

  test('play, move onto colored squares', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/3bp12/16/16/16/16/16/16/16/11wp4/16/16/16 1 w - b -'));
    expect(pos.armyManager.controls(Side.player1, PieceColor.red), false);
    final move = NormalMove(from: Square.l4, to: Square.l5);
    final pos1 = pos.play(move);
    expect(pos1.board.white.has(Square.l5), true);
    expect(pos1.armyManager.controls(Side.player1, PieceColor.red), true);
  });

  test('play, move off of colored squares', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/3bp12/16/16/16/16/16/16/11wp4/16/16/16/16 1 w r b -'));
    expect(pos.armyManager.controls(Side.player1, PieceColor.red), true);
    final move = NormalMove(from: Square.l5, to: Square.l6);
    final pos1 = pos.play(move);
    expect(pos1.board.white.has(Square.l6), true);
    expect(pos1.armyManager.controls(Side.player1, PieceColor.red), false);
  });

  test('play, promoting to king', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/7wp8/16/16/16/16/8wk7 1 w - b -'));
    final move =
        NormalMove(from: Square.h6, to: Square.h7, promotion: Role.king);
    expect(pos.board.kings.has(Square.i1), true);
    final result = pos.play(move);
    expect(result.board.pawns.has(Square.h6), false);
    expect(result.board.kings.has(Square.h7), true);
    expect(result.board.kings.has(Square.i1), false);
  });

  test('play, controlled pawn promotes to king', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/5rp10/16/11wp4/16/16/16/8wk7 1 w r b -'));
    final move =
        NormalMove(from: Square.f7, to: Square.g7, promotion: Role.king);
    expect(pos.board.kings.has(Square.i1), true);
    expect(pos.armyManager.ownedColor(Side.player1), PieceColor.white);
    final result = pos.play(move);
    expect(result.board.kings.has(Square.g7), true);
    expect(result.board.kings.has(Square.i1), false);
    expect(result.armyManager.ownedColor(Side.player1), PieceColor.red);
  });
}
