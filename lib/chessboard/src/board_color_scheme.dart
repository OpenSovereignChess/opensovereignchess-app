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
    background: SolidColorChessboardBackground(
      coordinates: true,
      grid: Color(0x88000000),
      promotionBox: Color(0xFF000000),
      pawnGuideline: Color(0xFF42150A),
      // Flutter Material Colors
      lightSquare: Color(0xFFFFF8E1), // amber 50
      darkSquare: Color(0xFFFFECB3), // amber 100
      ashSquare: Color(0xCCDDDDDD),
      blackSquare: Color(0xCC000000),
      cyanSquare: Color(0xCC7BAFDE),
      greenSquare: Color(0xCC4EB265),
      navySquare: Color(0xCC1965B0),
      orangeSquare: Color(0xCCF4A736),
      pinkSquare: Color(0xCCFFAFD2),
      redSquare: Color(0xCCDC050C),
      slateSquare: Color(0xCC777777),
      violetSquare: Color(0xCC882E72),
      whiteSquare: Color(0xCCFFFFFF),
      yellowSquare: Color(0xCCF7F056),
    ),
    selected: Color(0x6014551e),
    validMoves: Color.fromRGBO(152, 251, 152, 0.6),
  );
}
