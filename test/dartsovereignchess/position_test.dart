import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
  test('legalMoves', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/1wk14/16 1 w b -'));
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

  test('legalMoves, cannot capture own piece', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/8bpwp6/8wk7 1 w b -'));
    final kingLegalMoves = pos.legalMoves[Square.i1];
    expect(kingLegalMoves!.has(Square.i2), true);
    expect(kingLegalMoves.has(Square.j2), false);
  });

  test('legalMoves, cannot capture a neutral piece', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        'bk15/16/16/16/16/16/16/16/16/16/16/16/16/16/8pp7/8wk7 1 w b -'));
    final kingLegalMoves = pos.legalMoves[Square.i1];
    expect(pos.board.colorBelongsTo(Side.player1, PieceColor.pink), false);
    expect(pos.board.colorBelongsTo(Side.player2, PieceColor.pink), false);
    expect(kingLegalMoves!.has(Square.i2), false);
  });

  test('legalMoves, occupied color square', () {
    // We have a black pawn on a red square, so the white pawn on l4
    // cannot move to l5, the other red square.
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/4bp11/16/16/16/16/16/16/16/11wp4/16/16/8wk7 1 w b -'));
    expect(pos.legalMoves[Square.l4]!.has(Square.l5), false);
  });

  test('legalMoves, can capture a piece on colored square', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/9bq6/16/16/9wq6/16/16/16/16/16/8wk7 1 w b -'));
    expect(pos.legalMoves[Square.j7]!.has(Square.j10), true);
  });

  test('legalMoves, cannot move onto a square of its own color', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bq7/16/16/16/16/16/16/16/16/16/16/16/16/16/16/8bk7 2 w b -'));
    expect(pos.legalMoves[Square.i16]!.has(Square.i9), false);
  });

  test(
      'legalMoves, piece on colored square can move to other square of same color',
      () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/16/16/16/16/16/16/16/7wk8/16/16/16/16/16/16/16 1 w b -'));
    expect(pos.legalMoves[Square.h8]!.has(Square.i9), true);
  });

  test('legalMoves, king cannot move into check', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/br15/8wk7 1 w b -'));
    expect(pos.legalMoves[Square.i1]!.has(Square.i2), false);
  });

  test(
      'legalMoves, checked king can move to a square of the same color as the checker',
      () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/16/16/16/16/16/7bq8/16/16/7wk8/16/16/16/16/16/16 1 w b -'));
    expect(pos.legalMoves[Square.h7]!.has(Square.h8), true);
  });

  test('legalMoves, piece cannot move if king in check', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/wq15/16/16/16/16/16/16/16/16/16/16/16/16/16/br7wk7 1 w b -'));
    final legalMoves = pos.legalMoves;
    expect(legalMoves[Square.a15]!.isEmpty, true);
    expect(legalMoves[Square.i1]!.isNotEmpty, true);
  });

  test('legalMoves, can escape check by controlling checking piece', () {
    Position pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/16/6rq9/16/16/16/16/16/16/12bn3/16/11wp4/16/16/16/8wk7 2 w b -'));
    final legalMoves = pos.legalMoves;
    expect(pos.isCheck, true);
    expect(pos.board.colorControlledBy(Side.player1, PieceColor.red), true);
    expect(legalMoves[Square.i16]!.isNotEmpty, true);
    expect(legalMoves[Square.m7]!.isNotEmpty, true);

    pos = pos.play(NormalMove(from: Square.m7, to: Square.l5));
    expect(pos.isCheck, false);
    expect(pos.board.colorControlledBy(Side.player1, PieceColor.red), false);
    expect(pos.board.colorControlledBy(Side.player2, PieceColor.red), true);
  });

  test(
      'legalMoves, can escape check by controlling checking piece - chain of control',
      () {
    // Test owned color making the capture that leads to controlling the checker
    Position pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/16/5wq10/16/11bp4/5np4yp5/16/16/16/16/7gp8/16/16/16/16/8wk1vq5 1 w b -'));
    IMap<Square, SquareSet> legalMoves = pos.legalMoves;
    expect(pos.isCheck, true);
    expect(pos.board.colorControlledBy(Side.player2, PieceColor.violet), true);
    expect(legalMoves[Square.i1]!.isNotEmpty, true);
    expect(legalMoves[Square.f14]!.isNotEmpty, true);

    pos = pos.play(NormalMove(from: Square.f14, to: Square.f11));
    expect(pos.isCheck, false);
    expect(pos.board.colorControlledBy(Side.player1, PieceColor.violet), true);
    expect(pos.board.colorControlledBy(Side.player2, PieceColor.violet), false);

    // Test controlled color making the capture that leads to controlling the checker
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/16/5rq10/16/11bp4/5np4yp5/16/16/16/16/7gp8/11wp4/16/16/16/8wk1vq5 1 w b -'));
    legalMoves = pos.legalMoves;
    expect(pos.isCheck, true);
    expect(pos.board.colorControlledBy(Side.player2, PieceColor.violet), true);
    expect(legalMoves[Square.i1]!.isNotEmpty, true);
    expect(legalMoves[Square.f14]!.isNotEmpty, true);

    pos = pos.play(NormalMove(from: Square.f14, to: Square.f11));
    expect(pos.isCheck, false);
    expect(pos.board.colorControlledBy(Side.player1, PieceColor.violet), true);
    expect(pos.board.colorControlledBy(Side.player2, PieceColor.violet), false);

    // Another scenario from bug report
    pos = SovereignChess.fromSetup(Setup.parseFen(
        'aqabvrvnbrbnbb1bk1bnbrynyrsbsq/aranvpvpbpbpbpbp1bpbp1ypyp1sr/nbnp10sn1opob/nqnp6bp5opoq/crcp9bp2rprr/cncp8bq3rprn/1gp12pppb/gq2gp3gbwb5pppq/yqyp12vpvq/ybyp4bb7vpvb/onop6wq5npnn/orop12npnr/rqrp4wpwpwp5cpcq/rbrp10an1cpcb/srsnppppwpwp3wp1wp1gp1ar/sqsbprpnwrwn1aq1wkwn1gr1ab1 1 w b celn 32'));
    legalMoves = pos.legalMoves;
    expect(pos.isCheck, true);
    expect(legalMoves[Square.i9]!.squares, equals([Square.g7]));
  });

  test('legalMoves, blocker should remain pinned to king', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '8bk7/16/16/16/16/16/16/16/16/16/16/16/16/16/16/br3wq3wk7 1 w b -'));
    final legalMoves = pos.legalMoves;
    expect(legalMoves[Square.e1]!.has(Square.e2), false);
    expect(legalMoves[Square.e1]!.has(Square.f1), true);
  });

  test('play, move onto colored squares', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/3bp12/16/16/16/16/16/16/16/11wp4/16/16/8wk7 1 w b -'));
    expect(pos.board.armyManager.controls(Side.player1, PieceColor.red), false);
    final move = NormalMove(from: Square.l4, to: Square.l5);
    final pos1 = pos.play(move);
    expect(pos1.board.white.has(Square.l5), true);
    expect(pos1.board.armyManager.controls(Side.player1, PieceColor.red), true);
  });

  test('play, move off of colored squares', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/3bp12/16/16/16/16/16/16/11wp4/16/16/16/8wk7 1 w b -'));
    expect(pos.board.armyManager.controls(Side.player1, PieceColor.red), true);
    final move = NormalMove(from: Square.l5, to: Square.l6);
    final pos1 = pos.play(move);
    expect(pos1.board.white.has(Square.l6), true);
    expect(
        pos1.board.armyManager.controls(Side.player1, PieceColor.red), false);
  });

  test('play, promoting to king', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/7wp8/16/16/16/16/8wk7 1 w b -'));
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
        '16/16/16/16/16/16/16/16/16/5rp10/16/11wp4/16/16/16/8wk7 1 w b -'));
    final move =
        NormalMove(from: Square.f7, to: Square.g7, promotion: Role.king);
    expect(pos.board.kings.has(Square.i1), true);
    expect(pos.board.armyManager.colorOf(Side.player1), PieceColor.white);
    final result = pos.play(move);
    expect(result.board.kings.has(Square.g7), true);
    expect(result.board.kings.has(Square.i1), false);
    expect(result.board.armyManager.colorOf(Side.player1), PieceColor.red);
  });

  test('defect', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        'bk15/16/16/16/16/16/16/16/16/16/16/4wp11/16/16/16/8wk7 1 w b -'));
    expect(pos.board.kingOf(Side.player1), Square.i1);
    expect(pos.board.ownedColorOf(Side.player1), PieceColor.white);

    final newPos = pos.defect(PieceColor.navy);

    expect(pos.board.armyManager, isNot(newPos.board.armyManager));
    expect(newPos.board.ownedColorOf(Side.player1), PieceColor.navy);
    expect(newPos.board.kingOf(Side.player1), Square.i1);
    expect(newPos.board.pieceAt(Square.i1), Piece.navyKing);
    expect(newPos.board.controlledColorsOf(Side.player1), isEmpty);
  });

  test('legalCastlingMoves from initial position', () {
    final pos = SovereignChess.fromSetup(Setup.standard);
    expect(pos.legalCastlingMoves[Square.i1]!, SquareSet.empty);
    expect(pos.legalCastlingMoves[Square.i16], null);
    expect(pos.canCastle, false);
  });

  test('legalCastlingMoves', () {
    // Player 1 can castle with the two inner (white) rooks
    Position pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    expect(
        pos.legalCastlingMoves[Square.i1]!,
        SquareSet.fromSquares(
            [Square.f1, Square.g1, Square.h1, Square.j1, Square.k1]));
    expect(pos.legalCastlingMoves[Square.i16], null);
    expect(pos.canCastle, true);

    // Player 2 can castle with the two inner (black) rooks
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wk2wr1gr2 2 w b CELNceln'));
    expect(pos.legalCastlingMoves[Square.i1], null);
    expect(
        pos.legalCastlingMoves[Square.i16]!,
        SquareSet.fromSquares(
            [Square.f16, Square.g16, Square.h16, Square.j16, Square.k16]));

    // Player 1 can only castle queenside because there is a blocking piece on the kingside
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1brbn2bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wkwb1wr1gr2 1 w b CELNceln'));
    expect(pos.legalCastlingMoves[Square.i1]!,
        SquareSet.fromSquares([Square.f1, Square.g1, Square.h1]));
    expect(pos.legalCastlingMoves[Square.i16], null);

    // Player 2 can only castle kingside because there is a blocking piece on the queenside
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1brbn2bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wkwb1wr1gr2 2 w b CELNceln'));
    expect(pos.legalCastlingMoves[Square.i1], null);
    expect(pos.legalCastlingMoves[Square.i16]!,
        SquareSet.fromSquares([Square.j16, Square.k16]));

    // Player 2 can castle with queenside outer (violet) rook
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr5bk7/16/16/16/16/8bp7/16/16/16/16/16/16/16/16/16/2pr1wr3wkwb1wr1gr2 2 w b celn'));
    expect(pos.legalCastlingMoves[Square.i1], null);
    expect(
        pos.legalCastlingMoves[Square.i16]!,
        SquareSet.fromSquares(
            [Square.d16, Square.e16, Square.f16, Square.g16, Square.h16]));
  });

  test('legalCastlingMoves detects check', () {
    // King cannot castle while in check
    Position pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/8bq7/16/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    expect(pos.isCheck, true);
    expect(pos.legalCastlingMoves[Square.i1], null);

    // King cannot castle through check but can castle up to attacked square
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/6bq9/16/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    expect(pos.legalCastlingMoves[Square.i1]!,
        SquareSet.fromSquares([Square.h1, Square.j1, Square.k1]));
  });

  test('playCastle', () {
    Position pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    pos = pos.playCastle(NormalMove(from: Square.i1, to: Square.j1));
    expect(pos.board.pieceAt(Square.j1), Piece.whiteKing);
    expect(pos.board.pieceAt(Square.i1), Piece.whiteRook);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.king), null);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.queen), null);
  });

  test('moving a king or rook updates castle', () {
    // Move king
    Position pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    Move move = NormalMove(from: Square.i1, to: Square.i2);
    pos = pos.play(move);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.king), null);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.queen), null);

    // Move rook
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/16/16/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    move = NormalMove(from: Square.e1, to: Square.e2);
    pos = pos.play(move);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.king), Square.l1);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.queen), Square.c1);

    // Promote to king, thereby moving the king
    pos = SovereignChess.fromSetup(Setup.parseFen(
        '2vr1br3bk2br1yr2/16/16/16/16/16/16/16/16/16/7wp8/16/16/16/16/2pr1wr3wk2wr1gr2 1 w b CELNceln'));
    move = NormalMove(from: Square.h6, to: Square.h7, promotion: Role.king);
    pos = pos.play(move);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.king), null);
    expect(pos.castles.rookOf(Side.player1, CastlingSide.queen), null);
  });
}
