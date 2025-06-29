import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

/// Returns `true` if the move is a pawn promotion move that is not yet
/// promoted.
bool isPromotionPawnMove(Position position, NormalMove move) {
  return move.promotion == null &&
      position.board.roleAt(move.from) == Role.pawn &&
      promotionSquares.contains(move.to);
}
