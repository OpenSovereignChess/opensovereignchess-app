import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './board.dart';
import './models.dart';

/// A not necessarily legal position.
@immutable
class Setup {
  const Setup({
    required this.board,
    required this.turn,
    required this.p1Owned,
    required this.p1Controlled,
    required this.p2Owned,
    required this.p2Controlled,
    required this.ply,
  });

  /// Piece positions on the board.
  final Board board;

  /// Side to move.
  final Side turn;

  /// The color army player 1 owns.
  final PieceColor p1Owned;

  /// The color armies that player 1 controls.
  final ISet<PieceColor> p1Controlled;

  /// The color army player 2 owns.
  final PieceColor p2Owned;

  /// The color armies that player 2 controls.
  final ISet<PieceColor> p2Controlled;

  /// Current half-move number.
  ///
  /// Gets incremented after any player makes a turn.
  final int ply;

  /// Parses a Sovereign Chess FEN string and returns a [Setup].
  ///
  /// - Accepts missing FEN fields (except the board) and fills them with
  ///   default values of `16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16 1 w b - - 0`
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

    // p1 controlled armies
    ISet<PieceColor> p1Controlled;
    if (parts.isEmpty) {
      p1Controlled = ISet.empty();
    } else {
      final p1ControlledPart = parts.removeAt(0);
      if (p1ControlledPart[0] == '-') {
        p1Controlled = ISet.empty();
      } else {
        final colors = p1ControlledPart.characters.map((c) {
          final color = PieceColor.fromChar(c);
          if (color == null) {
            throw const FenException(IllegalFenCause.p1Controlled);
          } else {
            return color;
          }
        });
        p1Controlled = colors.toISet();
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

    // p2 controlled armies
    ISet<PieceColor> p2Controlled;
    if (parts.isEmpty) {
      p2Controlled = ISet.empty();
    } else {
      final p2ControlledPart = parts.removeAt(0);
      if (p2ControlledPart[0] == '-') {
        p2Controlled = ISet.empty();
      } else {
        final colors = p2ControlledPart.characters.map((c) {
          final color = PieceColor.fromChar(c);
          if (color == null) {
            throw const FenException(IllegalFenCause.p2Controlled);
          } else {
            return color;
          }
        });
        p2Controlled = colors.toISet();
      }
    }

    int ply;
    if (parts.isEmpty) {
      ply = 0;
    } else {
      ply = int.parse(parts.removeAt(0));
    }

    return Setup(
      board: board,
      turn: turn,
      p1Owned: p1Owned,
      p1Controlled: p1Controlled,
      p2Owned: p2Owned,
      p2Controlled: p2Controlled,
      ply: ply,
    );
  }

  /// FEN representation of the setup.
  String get fen => [
        board.fen,
        turn.name[turn.name.length - 1],
        p1Owned.letter,
        p1Controlled.isNotEmpty
            ? p1Controlled.fold('', (prev, i) => prev + i.letter)
            : '-',
        p2Owned.letter,
        p2Controlled.isNotEmpty
            ? p2Controlled.fold('', (prev, i) => prev + i.letter)
            : '-',
        ply,
      ].join(' ');
}
