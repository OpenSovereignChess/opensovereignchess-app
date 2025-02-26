import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/board.dart';

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
}
