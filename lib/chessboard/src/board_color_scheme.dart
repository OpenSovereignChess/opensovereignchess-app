import 'package:flutter/widgets.dart';
import './widgets/background.dart';

/// Describes the color scheme of a [ChessboardBackground].
///
/// Use the `static const` members to ensure flutter doesn't rebuild the board
/// background more than necessary.
@immutable
class ChessboardColorScheme {
  const ChessboardColorScheme({
    required this.lightSquare,
    required this.darkSquare,
    required this.background,
    required this.selected,
  });

  /// Light square color of the board
  final Color lightSquare;

  /// Dark square color of the board
  final Color darkSquare;

  /// Board background that defines light and dark square colors
  final ChessboardBackground background;

  /// Color of highlighted selected square
  final Color selected;

  static const original = ChessboardColorScheme(
    lightSquare: Color(0xAAE5E0DF),
    darkSquare: Color(0xAACAC5C4),
    background: ChessboardBackground(
      lightSquare: Color(0xAAE5E0DF), // IBM color palette warm gray
      darkSquare: Color(0xAACAC5C4), // IBM color palette warm gray
    ),
    selected: Color(0x6014551e),
  );
}
