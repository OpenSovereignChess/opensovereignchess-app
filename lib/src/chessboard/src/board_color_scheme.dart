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
  });

  /// Light square color of the board
  final Color lightSquare;

  /// Dark square color of the board
  final Color darkSquare;

  /// Board background that defines light and dark square colors
  final ChessboardBackground background;

  static const original = ChessboardColorScheme(
    lightSquare: Color(0xfff0d9b6),
    darkSquare: Color(0xffb58863),
    background: ChessboardBackground(
      // DECFBA 222 207 186
      lightSquare: Color.fromRGBO(222, 207, 186, 1.0),
      // CBB393 203 179 147
      darkSquare: Color.fromRGBO(203, 179, 147, 1.0),
    ),
  );
}
