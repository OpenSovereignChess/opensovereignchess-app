import 'package:test/test.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';

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
