import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

void main() {
  test('makeLegalMoves', () {
    final setup = Setup.parseFen(
      '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/wk15',
    );
    final pos = SovereignChess.fromSetup(setup);
    final moves = makeLegalMoves(pos);
    expect(moves[Square.a1], contains(Square.a2));
  });
}
