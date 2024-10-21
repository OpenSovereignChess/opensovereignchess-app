/// A not necessarily legal position.
@immutable
class Setup {
  /// Creates a new [Setup] with the provided values.
  //const Setup({
  //
  //});

  /// Parses a Sovereign Chess FEN string and returns a [Setup].
  ///
  /// - Accepts missing FEN fields (except the board) and fills them with
  ///   default values of `16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16 1 - - - - 0`
  /// - Accepts multiple spaces as separators between FEN fields.
  ///
  /// Throws a [FenException] if the provided FEN is not valid.
  factory Setup.parseFen(String fen) {
    final parts = fen.split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      throw const FenException(IllegalFenCause.format);
    }

    // board
    final boardPart = parts.removeAt(0);
    //Board board;
  }
}
