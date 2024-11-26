import 'package:fast_immutable_collections/fast_immutable_collections.dart'; // For testing purposes
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

part 'over_the_board_game_controller.g.dart';

final initialFen =
    'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbpbpbpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp12rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop12npnn/orop12npnr/rqrp12cpcq/rbrp12cpcb/srsnppppwpwpwpwpwpwpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq';

@riverpod
class OverTheBoardGameController extends _$OverTheBoardGameController {
  @override
  OverTheBoardGameState build() => OverTheBoardGameState(
        position: SovereignChess.fromSetup(Setup.parseFen(initialFen)),
      );

  void makeMove(NormalMove move) {
    final newPos = state.position.play(move);
    state = state.copyWith(
      position: newPos,
    );
  }
}

class OverTheBoardGameState {
  const OverTheBoardGameState({
    required this.position,
  });

  final Position position;

  OverTheBoardGameState copyWith({
    Position? position,
  }) {
    return OverTheBoardGameState(
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OverTheBoardGameState && position == other.position;
  }

  @override
  int get hashCode {
    return Object.hash(position, null);
  }

  IMap<Square, ISet<Square>> get legalMoves => makeLegalMoves(position);
}
