import 'package:fast_immutable_collections/fast_immutable_collections.dart'; // For testing purposes
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/src/model/common/sovereignchess.dart';

part 'over_the_board_game_controller.g.dart';

@riverpod
class OverTheBoardGameController extends _$OverTheBoardGameController {
  @override
  OverTheBoardGameState build(String? initialFen) => OverTheBoardGameState(
        position:
            SovereignChess.fromSetup(Setup.parseFen(initialFen ?? kInitialFEN)),
      );

  void makeMove(NormalMove move, {PieceColor? color}) {
    if (isPromotionPawnMove(state.position, move)) {
      state = state.copyWith(promotionMove: move, promotionColor: color);
      return;
    }
    final newPos = state.position.play(move);
    state = state.copyWith(
      position: newPos,
    );
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = state.copyWith(promotionMove: null);
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final move = promotionMove.withPromotion(role);
      makeMove(move);
      state = state.copyWith(promotionMove: null);
    }
  }
}

class OverTheBoardGameState {
  const OverTheBoardGameState({
    required this.position,
    this.promotionMove,
    this.promotionColor,
  });

  final Position position;

  final NormalMove? promotionMove;

  final PieceColor? promotionColor;

  OverTheBoardGameState copyWith({
    Position? position,
    NormalMove? promotionMove,
    PieceColor? promotionColor,
  }) {
    return OverTheBoardGameState(
      position: position ?? this.position,
      promotionMove: promotionMove,
      promotionColor: promotionColor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OverTheBoardGameState &&
        position == other.position &&
        promotionMove == other.promotionMove &&
        promotionColor == other.promotionColor;
  }

  @override
  int get hashCode {
    return Object.hash(position, promotionMove, promotionColor);
  }

  IMap<Square, ISet<Square>> get legalMoves => makeLegalMoves(position);
}
