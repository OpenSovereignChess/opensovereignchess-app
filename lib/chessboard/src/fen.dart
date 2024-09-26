import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:flutter/widgets.dart';

import './models.dart';

/// Parses the board part of a FEN string.
Pieces readFen(String fen) {
  final Pieces pieces = {};
  int rank = Rank.values.last as int;
  int file = 0;
  String pieceToken = '';
  String skippedToken = '';

  for (final c in fen.characters) {
    switch (c) {
      case ' ':
        return pieces;
      case '/':
        --rank;
        if (rank < 0) {
          return pieces;
        }
        file = 0;
        skippedToken = '';
      default:
        final code = c.codeUnitAt(0);
        // Check if code is a digit, and not a letter
        if (code < 58) {
          skippedToken += c;
        } else {
          pieceToken += c;

          // Process skipped spaces if any
          if (skippedToken.length > 0) {
            final skippedSpaces = int.parse(skippedToken);
            file += skippedSpaces;
            skippedToken = '';
          }
        }

        // Piece token will always be two chars - a color and a role.
        if (pieceToken.length == 2) {
          final colorLetter = pieceToken[0];
          final roleLetter = pieceToken[1];
          final square = Square.fromCoords(File(file), Rank(rank));
          pieces[square] = Piece(
            color: PieceColor.fromChar(colorLetter)!,
            role: Role.fromChar(roleLetter)!,
          );
          ++file;
          pieceToken = '';
        }
    }
  }

  return pieces;
}

/// Converts the pieces to the board part of a FEN string.
String writeFen(Pieces pieces) {
  final buffer = StringBuffer();
  int empty = 0;
  int lastFile = File.values.length - 1;
  for (int rank = Rank.values.length - 1; rank >= 0; rank--) {
    for (int file = 0; file < File.values.length; file++) {
      final piece = pieces[Square.fromCoords(File(file), Rank(rank))];
      if (piece == null) {
        empty++;
      } else {
        if (empty > 0) {
          buffer.write(empty.toString());
          empty = 0;
        }
        buffer.write(piece.fenStr);
      }

      if (file == lastFile) {
        if (empty > 0) {
          buffer.write(empty.toString());
          empty = 0;
        }
        if (rank != 0) {
          buffer.write('/');
        }
      }
    }
  }
  return buffer.toString();
}
