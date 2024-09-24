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
      // IBM color palette warm gray
      lightSquare: Color(0xAAE5E0DF),
      darkSquare: Color(0xAACAC5C4),
      // Flutter Material Colors
      //lightSquare: Color(0xFFFFF8E1), // amber 50
      //darkSquare: Color(0xFFFFECB3), // amber 100
    ),
    selected: Color(0x6014551e),
  );
}
