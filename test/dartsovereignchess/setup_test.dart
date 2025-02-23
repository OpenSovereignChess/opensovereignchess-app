import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/setup.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
  test('parseFen', () {
    final setup = Setup.parseFen(
        '16/16/16/16/16/7bp8/16/16/5wq1wb8/16/16/4wp11/16/16/16/wk15 1 w b CELNceln 0');
    expect(setup.turn, Side.player1);
    expect(setup.board.armyManager.colorOf(Side.player1), PieceColor.white);
    expect(setup.board.armyManager.colorOf(Side.player2), PieceColor.black);
    expect(setup.board.armyManager.p1Controlled,
        ISet({PieceColor.navy, PieceColor.cyan}));
    expect(setup.board.armyManager.p2Controlled, ISet({PieceColor.pink}));
    expect(setup.castlingRights, makeSquareSet('''
. . 1 . 1 . . . . . . 1 . 1 . .
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
. . . . . . . . . . . . . . . .
. . 1 . 1 . . . . . . 1 . 1 . .
'''));
  });

  test('fen', () {
    final fen = '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b - 0';
    final setup = Setup.parseFen(fen);
    expect(setup.fen, fen);
  });

  // Test the castling rights part of the FEN AI!
}
