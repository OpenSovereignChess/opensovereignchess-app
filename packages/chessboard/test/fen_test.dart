import 'package:test/test.dart';
import 'package:chessboard/chessboard.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';

const initialFen =
    'aq1bk13/16/15gb/16/5wp5wp4/16/rqrp2wp9cpcq/16/16/16/16/16/16/16/16/pr15';

void main() {
  test('Read fen', () {
    final pieces = readFen(initialFen);
    expect(pieces.length, 11);
    expect(pieces[Square.a1]!.kind, PieceKind.pinkRook);
    expect(pieces[Square.a16]!.kind, PieceKind.ashQueen);
    expect(pieces[Square.p14]!.kind, PieceKind.greenBishop);
    expect(pieces[Square.f12]!.kind, PieceKind.whitePawn);
    expect(pieces[Square.l12]!.kind, PieceKind.whitePawn);
    expect(pieces[Square.c16]!.kind, PieceKind.blackKing);
    expect(pieces[Square.e10]!.kind, PieceKind.whitePawn);
  });

  test('Write fen', () {
    final Pieces pieces = {
      Square.a16: Piece(color: PieceColor.black, role: Role.king),
    };
    final fen = writeFen(pieces);
    expect(fen, 'bk15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16');
  });
}
