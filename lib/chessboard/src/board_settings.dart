import 'package:flutter/widgets.dart';

import 'board_color_scheme.dart';

/// Board settings that controls visual aspects and behavior of the board.
///
/// This is meant for fixed settings that don't change during a game. Sensible
/// defaults are provided.
@immutable
class ChessboardSettings {
  const ChessboardSettings({
    // theme
    this.colorScheme = ChessboardColorScheme.original,
  });

  /// Theme of the board
  final ChessboardColorScheme colorScheme;
}