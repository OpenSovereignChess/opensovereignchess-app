import 'package:flutter/widgets.dart';
import './widgets/background.dart';

/// Describes the color scheme of a [ChessboardBackground].
///
/// Use the `static const` members to ensure flutter doesn't rebuild the board
/// background more than necessary.
@immutable
class ChessboardColorScheme {
  const ChessboardColorScheme({
    required this.background,
    required this.selected,
    required this.validMoves,
  });

  /// Board background that defines light and dark square colors
  final ChessboardBackground background;

  /// Color of highlighted selected square
  final Color selected;

  /// Color of squares occupied with valid moves dots
  final Color validMoves;

  static const original = ChessboardColorScheme(
    background: ChessboardBackground(
      grid: Color(0x88000000),
      // Flutter Material Colors
      lightSquare: Color(0xFFFFF8E1), // amber 50
      darkSquare: Color(0xFFFFECB3), // amber 100
    ),
    selected: Color(0x6014551e),
    validMoves: Color.fromRGBO(152, 251, 152, 0.6),
  );
}
