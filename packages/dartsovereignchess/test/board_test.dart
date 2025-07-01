import 'package:test/test.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';
import 'package:dartsovereignchess/src/board.dart';
//import 'package:dartsovereignchess/src/debug.dart';

void main() {
  test('setPieceAt', () {
    const piece = Piece.whiteKing;
    Board board = Board.empty.setPieceAt(Square.a1, piece);
    expect(board.pieceAt(Square.a1), piece);

    board = board.setPieceAt(Square.a1, Piece.whiteQueen);
    expect(board.pieceAt(Square.a1), Piece.whiteQueen);
  });

  test('parseFen', () {
    final board =
        Board.parseFen('16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/bk15');
    expect(board.pieceAt(Square.a1), Piece.blackKing);

    final board2 = Board.parseFen(kInitialBoardFEN);
    expect(board2.pieceAt(Square.a1), Piece.slateQueen);
    expect(board2.pieceAt(Square.p16), Piece.slateQueen);
  });

  test('attacksTo', () {
    final pos = SovereignChess.fromSetup(Setup.parseFen(
        'aqabvrvnbrbn1bq3yp1yrsbsq/aranvpvpbpbpbp1bnbk3yp1sr/1np10sn1opob/nq2np12/crcp9bb2rprr/cncp3wq1bp6rprn/gbgp12pppb/gqgp12pppq/yqyp8wb3vpvq/ybyp12vpvb/onop10np1npnn/orop5nr8/rqrp6wp5cpcq/rbrp12cpcb/srsnppppwpwpwpwp1wpwpwpgpgpanar/sqsbprpnwrwnwb1wk1wnwrgngrabaq 2 w b CELN'));
    final board = pos.board;
    // White queen should be attacking i14
    expect(board.attacksTo(Square.i14, Side.player1),
        SquareSet.fromSquare(Square.f11));
    // Yellow pawn should be attacking k15
    expect(board.attacksTo(Square.k15, Side.player1),
        SquareSet.fromSquare(Square.l16));
  });
}
