import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

const initialFen =
    'aq1bk13/16/15gb/16/5wp5wp4/16/16/16/16/16/16/16/16/16/16/pr15';

void main() {
  test('Read fen', () {
    final pieces = readFen(initialFen);
    expect(pieces.length, 6);
    expect(pieces[Square.a1]!.kind, equals((PieceColor.pink, Role.rook)));
    expect(pieces[Square.a16]!.kind, equals((PieceColor.ash, Role.queen)));
    expect(pieces[Square.p14]!.kind, equals((PieceColor.green, Role.bishop)));
    expect(pieces[Square.f12]!.kind, equals((PieceColor.white, Role.pawn)));
    expect(pieces[Square.l12]!.kind, equals((PieceColor.white, Role.pawn)));
    expect(pieces[Square.c16]!.kind, equals((PieceColor.black, Role.king)));
  });
}