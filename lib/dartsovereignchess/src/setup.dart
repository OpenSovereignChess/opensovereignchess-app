import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './army_manager.dart';
import './board.dart';
import './models.dart';
import './square_set.dart';

/// A not necessarily legal position.
@immutable
class Setup {
  const Setup({
    required this.board,
    required this.turn,
    required this.castlingRights,
    required this.ply,
  });

  /// Piece positions on the board.
  final Board board;

  /// Side to move.
  final Side turn;

  /// Unmoved rooks positions used to determine castling rights.
  final SquareSet castlingRights;

  /// Current half-move number.
  ///
  /// Gets incremented after any player makes a turn.
  final int ply;

  /// Parses a Sovereign Chess FEN string and returns a [Setup].
  ///
  /// - Accepts missing FEN fields (except the board) and fills them with
  ///   default values of `16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16 1 w b CELNceln 0`
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
    Board board = Board.parseFen(boardPart);

    // turn
    Side turn;
    if (parts.isEmpty) {
      turn = Side.player1;
    } else {
      final turnPart = parts.removeAt(0);
      turn = switch (turnPart) {
        '1' => Side.player1,
        '2' => Side.player2,
        _ => throw const FenException(IllegalFenCause.turn),
      };
    }

    // p1 owned army
    PieceColor p1Owned;
    if (parts.isEmpty) {
      p1Owned = PieceColor.white;
    } else {
      final p1OwnedPart = parts.removeAt(0);
      final color = PieceColor.fromChar(p1OwnedPart);
      if (color == null) {
        throw const FenException(IllegalFenCause.p1Owned);
      } else {
        p1Owned = color;
      }
    }

    // p2 owned army
    PieceColor p2Owned;
    if (parts.isEmpty) {
      p2Owned = PieceColor.black;
    } else {
      final p2OwnedPart = parts.removeAt(0);
      final color = PieceColor.fromChar(p2OwnedPart);
      if (color == null) {
        throw const FenException(IllegalFenCause.p2Owned);
      } else {
        p2Owned = color;
      }
    }

    final armyManager = _parseControlledArmies(board, p1Owned, p2Owned);

    // Castling
    SquareSet castlingRights;
    if (parts.isEmpty) {
      castlingRights = SquareSet.empty;
    } else {
      final castlingPart = parts.removeAt(0);
      castlingRights = _parseCastlingFen(board, castlingPart);
    }

    int ply;
    if (parts.isEmpty) {
      ply = 0;
    } else {
      ply = int.parse(parts.removeAt(0));
    }

    return Setup(
      board: board.copyWith(armyManager: armyManager),
      turn: turn,
      castlingRights: castlingRights,
      ply: ply,
    );
  }

  /// FEN representation of the setup.
  String get fen => [
        board.fen,
        turn.name[turn.name.length - 1],
        board.armyManager.p1Owned.letter,
        board.armyManager.p2Owned.letter,
        '-',
        ply,
      ].join(' ');
}

SquareSet _parseCastlingFen(Board board, String castlingPart) {
  SquareSet castlingRights = SquareSet.empty;
  if (castlingPart == '-') {
    return castlingRights;
  }
  for (final rune in castlingPart.runes) {
    final c = String.fromCharCode(rune);
    final lower = c.toLowerCase();
    final lowerCode = lower.codeUnitAt(0);
    final side = c == lower ? Side.player2 : Side.player1;
    final rank = side == Side.player1 ? Rank.first : Rank.sixteenth;
    if ('a'.codeUnitAt(0) <= lowerCode && lowerCode <= 'p'.codeUnitAt(0)) {
      castlingRights = castlingRights.withSquare(
          Square.fromCoords(File(lowerCode - 'a'.codeUnitAt(0)), rank));
    } else {
      throw const FenException(IllegalFenCause.castling);
    }
  }
  if (Side.values.any((side) =>
      SquareSet.backrankOf(side).intersect(castlingRights).size > 4)) {
    throw const FenException(IllegalFenCause.castling);
  }
  return castlingRights;
}

// Follow the chain of which colors control which colors until the end.
// If the end is p1Owned or p2Owned, then add the controlled color to the controlled set.
// Cannot control an owned army.
ArmyManager _parseControlledArmies(
    Board board, PieceColor p1Owned, PieceColor p2Owned) {
  final owned = {p1Owned, p2Owned};
  final controlledBy = Map<PieceColor, PieceColor>();
  for (final color in PieceColor.values) {
    if (owned.contains(color)) {
      continue;
    }
    final piece = board.pieceOnSquareOf(color);
    if (piece != null) {
      controlledBy[color] = piece.color;
    }
  }

  PieceColor _findFinalOwner(PieceColor color) {
    color = controlledBy[color]!;
    while (controlledBy[color] != null) {
      color = controlledBy[color]!;
    }
    return color;
  }

  final p1Controlled = <PieceColor>{};
  final p2Controlled = <PieceColor>{};

  for (final key in controlledBy.keys) {
    if (_findFinalOwner(key) == p1Owned) {
      p1Controlled.add(key);
    } else if (_findFinalOwner(key) == p2Owned) {
      p2Controlled.add(key);
    }
  }

  return ArmyManager(
    p1Owned: p1Owned,
    p2Owned: p2Owned,
    p1Controlled: p1Controlled.toISet(),
    p2Controlled: p2Controlled.toISet(),
  );
}
