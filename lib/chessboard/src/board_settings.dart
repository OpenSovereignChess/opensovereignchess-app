import 'package:flutter/widgets.dart';

import 'board_color_scheme.dart';
import 'models.dart';
import 'piece_set.dart';

/// Board settings that controls visual aspects and behavior of the board.
///
/// This is meant for fixed settings that don't change during a game. Sensible
/// defaults are provided.
@immutable
class ChessboardSettings {
  const ChessboardSettings({
    // theme
    this.colorScheme = ChessboardColorScheme.original,
    this.pieceAssets = PieceSet.wikimediaAssets,
    this.showValidMoves = true,
    this.dragFeedbackScale = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
  });

  /// Theme of the board
  final ChessboardColorScheme colorScheme;

  /// Piece set
  final PieceAssets pieceAssets;

  /// Whether to show valid moves
  final bool showValidMoves;

  /// Scale up factor for the piece currently under drag
  final double dragFeedbackScale;

  /// Offset for the piece currently under drag
  final Offset dragFeedbackOffset;
}
