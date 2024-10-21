import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

/// Game data for an interactive chessboard.
///
/// This is used to control the state of the chessboard and to provide callbacks for user interactions.
@immutable
class GameData {
  /// Creates a new [GameData] with the provided values.
  const GameData({
    required this.validMoves,
    required this.onMove,
  });

  /// Set of moves allowed to be played by current side to move.
  final ValidMoves validMoves;

  /// Callback called after a move has been made.
  ///
  /// If the move has been made with drag and drop, `isDrop` will be true.
  final void Function(NormalMove, {bool? isDrop}) onMove;
}

/// Describes a set of piece assets.
///
/// The [PieceAssets] must be complete with all the pieces for both sides.
typedef PieceAssets = IMap<PieceKind, SvgPicture>;

/// Representation of the piece positions on a board.
typedef Pieces = Map<Square, Piece>;

/// Sets of each valid destinations for an origin square.
typedef ValidMoves = IMap<Square, ISet<Square>>;
