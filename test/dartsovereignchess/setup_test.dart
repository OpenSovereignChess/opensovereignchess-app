import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
  test('parseFen', () {
    final setup = Setup.parseFen(
        '16/16/16/16/16/7bp8/16/16/5wq1wb8/16/16/4wp11/16/16/16/wk15 1 w b CELNceln 0');
    expect(setup.turn, Side.player1);
    expect(setup.board.armyManager.colorOf(Side.player1), PieceColor.white);
    expect(setup.board.armyManager.colorOf(Side.player2), PieceColor.black);
    expect(setup.board.controlledColorsOf(Side.player1),
        ISet({PieceColor.navy, PieceColor.cyan}));
    expect(
        setup.board.controlledColorsOf(Side.player2), ISet({PieceColor.pink}));
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

  test('castling rights in FEN', () {
    // Test empty castling rights
    var setup = Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b - 0');
    expect(setup.castlingRights, SquareSet.empty);

    // Test all castling rights
    setup = Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b CELNceln 0');
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

    // Test partial castling rights
    setup = Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b CLen 0');
    expect(setup.castlingRights, makeSquareSet('''
. . . . 1 . . . . . . . . 1 . .
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
. . 1 . . . . . . . . 1 . . . .
'''));

    // Test invalid castling rights throws FenException
    expect(
        () => Setup.parseFen(
            '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b XYZ 0'),
        throwsA(isA<FenException>()
            .having((e) => e.cause, 'cause', IllegalFenCause.castling)));
  });

  test('writing castling rights to FEN', () {
    // Test empty castling rights
    var setup = Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b - 0');
    expect(setup.fen,
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b - 0');

    // Test all castling rights
    setup = Setup.parseFen(
        'bk15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b CELNceln 0');
    expect(setup.fen,
        'bk15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b CELNceln 0');

    // Test partial castling rights
    setup = Setup.parseFen(
        'bk15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b CLen 0');
    expect(setup.fen,
        'bk15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w b CLen 0');
  });
}
