import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './attacks.dart';
import './board.dart';
import './models.dart';
import './pawn_moves.dart';
import './setup.dart';
import './square_set.dart';

/// A base class for playable Sovereign Chess or variant positions.
///
/// See [SovereignChess] for a concrete implementation of standard rules.
@immutable
abstract class Position<T extends Position<T>> {
  const Position({
    required this.board,
    required this.turn,
    required this.p1Owned,
    required this.p1Controlled,
    required this.p2Owned,
    required this.p2Controlled,
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

  /// The [Rule] of this position.
  Rule get rule;

  /// Creates a copy of this position with some fields changed.
  Position<T> copyWith({
    Board? board,
    Side? turn,
    PieceColor? p1Owned,
    ISet<PieceColor>? p1Controlled,
    PieceColor? p2Owned,
    ISet<PieceColor>? p2Controlled,
  });

  /// Create a [Position] from a [Setup] and [Rule].
  static Position setupPosition(Setup setup,
      {Rule rule = Rule.sovereignChess}) {
    return switch (rule) {
      Rule.sovereignChess => SovereignChess.fromSetup(setup),
    };
  }

  ISet<PieceColor> _sideColors(Side turn) {
    if (turn == Side.player1) {
      return [
        p1Owned,
        ...p1Controlled,
      ].toISet();
    }
    if (turn == Side.player2) {
      return [
        p2Owned,
        ...p2Controlled,
      ].toISet();
    }
    return ISet.empty();
  }

  /// Gets all the legal moves of this position.
  ///
  /// Returns a [SquareSet] of all the legal moves for each [Square].
  ///
  /// Use the [makeLegalMoves] helper to get all the legal moves including alternative
  /// castling moves.
  IMap<Square, SquareSet> get legalMoves {
    final context = _makeContext();
    return IMap({
      for (final s
          in _sideColors(turn).fold<List<Square>>([], (previousValue, color) {
        final squares = board.byColor(color).squares;
        //print('DEBUG=== color=$color squares=$squares');
        return [...previousValue, ...squares];
      }))
        s: _legalMovesOf(s, context: context)
    });
  }

  /// Gets the legal moves for that [Square].
  ///
  /// Optionally pass a [_Context] of the position, to optimize performance when
  /// calling this method several times.
  SquareSet _legalMovesOf(Square square, {_Context? context}) {
    final ctx = context ?? _makeContext();
    final piece = board.pieceAt(square);
    if (piece == null || !_sideColors(turn).contains(piece.color)) {
      return SquareSet.empty;
    }

    SquareSet pseudo;
    if (piece.role == Role.pawn) {
      pseudo = (pawnAttacks(square) & board.occupied) |
          pawnMoves(square, board.occupied);
    } else if (piece.role == Role.bishop) {
      pseudo = bishopAttacks(square, board.occupied);
    } else if (piece.role == Role.knight) {
      pseudo = knightAttacks(square);
    } else if (piece.role == Role.rook) {
      pseudo = rookAttacks(square, board.occupied);
    } else if (piece.role == Role.queen) {
      pseudo = queenAttacks(square, board.occupied);
    } else {
      pseudo = kingAttacks(square);
    }

    // Include colors that aren't controlled because we cannot attack those pieces
    pseudo = pseudo.diff(board.exclude(_sideColors(turn.opposite)));
    return pseudo;
  }

  _Context _makeContext() {
    final king = board.kingOf(turn);
    return _Context(
      king: king,
    );
  }
}

/// A standard Sovereign Chess position.
@immutable
class SovereignChess extends Position<SovereignChess> {
  const SovereignChess({
    required super.board,
    required super.turn,
    required super.p1Owned,
    required super.p1Controlled,
    required super.p2Owned,
    required super.p2Controlled,
  });

  @override
  Rule get rule => Rule.sovereignChess;

  /// Sets up a playable [SovereignChess] position.
  ///
  /// Throws a [PositionSetupException] if the [Setup] does not meet basic validity
  /// requirements.
  factory SovereignChess.fromSetup(Setup setup) {
    final pos = SovereignChess(
      board: setup.board,
      turn: setup.turn,
      p1Owned: setup.p1Owned,
      p1Controlled: setup.p1Controlled,
      p2Owned: setup.p2Owned,
      p2Controlled: setup.p2Controlled,
    );
    return pos;
  }

  @override
  SovereignChess copyWith({
    Board? board,
    Side? turn,
    PieceColor? p1Owned,
    ISet<PieceColor>? p1Controlled,
    PieceColor? p2Owned,
    ISet<PieceColor>? p2Controlled,
  }) {
    return SovereignChess(
      board: board ?? this.board,
      turn: turn ?? this.turn,
      p1Owned: p1Owned ?? this.p1Owned,
      p1Controlled: p1Controlled ?? this.p1Controlled,
      p2Owned: p2Owned ?? this.p2Owned,
      p2Controlled: p2Controlled ?? this.p2Controlled,
    );
  }
}

@immutable
class _Context {
  const _Context({
    required this.king,
  });

  final Square? king;

  _Context copyWith({
    Square? king,
  }) {
    return _Context(
      king: king,
    );
  }
}
