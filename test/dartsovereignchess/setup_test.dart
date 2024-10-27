import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/setup.dart';

void main() {
  test('parseFen', () {
    final setup = Setup.parseFen(
        '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15 1 w nc b p 0');
    expect(setup.turn, Side.player1);
    expect(setup.p1Owned, PieceColor.white);
    expect(setup.p2Owned, PieceColor.black);
    expect(setup.p1Controlled, ISet({PieceColor.navy, PieceColor.cyan}));
    expect(setup.p2Controlled, ISet({PieceColor.pink}));
  });
}
