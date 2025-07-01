import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';

/// Game data for an interactive chessboard.
///
/// This is used to control the state of the chessboard and to provide callbacks for user interactions.
@immutable
class GameData {
  /// Creates a new [GameData] with the provided values.
  const GameData({
    required this.sideToMove,
    required this.validMoves,
    required this.onMove,
    required this.promotionMove,
    required this.promotionColor,
    required this.onPromotionSelection,
    this.promotionRoles,
    this.isCheck,
    this.checkedKingColor,
  });

  /// Side which is to move.
  final Side sideToMove;

  /// Set of moves allowed to be played by current side to move.
  final ValidMoves validMoves;

  /// Callback called after a move has been made.
  ///
  /// If the move has been made with drag and drop, `isDrop` will be true.
  final void Function(NormalMove, {bool? isDrop, PieceColor color}) onMove;

  /// A pawn move that should be promoted.
  ///
  /// Will show a promotion dialog if not null.
  final NormalMove? promotionMove;

  /// We're keeping track of the color here, instead of modifying the core
  /// NormalMove class.  If it seems like we need it elsewhere, then we
  /// can refactor the logic accordingly.
  final PieceColor? promotionColor;

  /// Callback called after a piece has been selected for promotion.
  ///
  /// If the argument is `null`, the promotion should be canceled.
  final void Function(Role? role) onPromotionSelection;

  /// The roles that we can promote to.
  final ISet<Role>? promotionRoles;

  /// Hightlight the king of current side to move
  final bool? isCheck;

  /// Color of the king in check
  final PieceColor? checkedKingColor;
}

/// Describes a set of piece assets.
///
/// The [PieceAssets] must be complete with all the pieces for both sides.
typedef PieceAssets = IMap<PieceKind, SvgPicture>;

/// Representation of the piece positions on a board.
typedef Pieces = Map<Square, Piece>;

/// Sets of each valid destinations for an origin square.
typedef ValidMoves = IMap<Square, ISet<Square>>;

/// Base class for shapes that can be drawn on the board.
sealed class Shape {
  /// Scale factor for the shape. Must be between 0.0 and 1.0.
  double get scale => 1.0;

  /// Decides what shape to draw based on the current shape and the new destination.
  Shape newDest(Square newDest);

  /// Returns a new shape with the same properties but a different scale.
  Shape withScale(double scale);
}
