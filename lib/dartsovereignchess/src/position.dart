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

  // Current half-move number.
  final int ply;

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
    int? ply,
  });

  /// Create a [Position] from a [Setup] and [Rule].
  static Position setupPosition(Setup setup,
      {Rule rule = Rule.sovereignChess}) {
    return switch (rule) {
      Rule.sovereignChess => SovereignChess.fromSetup(setup),
    };
  }

  /// Gets the FEN string of this position.
  ///
  /// Contrary to the FEN given by [Setup], this should always be a legal
  /// position.
  String get fen {
    return Setup(
      board: board,
      turn: turn,
      p1Owned: p1Owned,
      p1Controlled: p1Controlled,
      p2Owned: p2Owned,
      p2Controlled: p2Controlled,
      ply: ply,
    ).fen;
  }

  /// Tests a move for legality.
  bool isLegal(Move move) {
    switch (move) {
      case NormalMove(from: final f, to: final t, promotion: final p):
        if (p == Role.pawn) {
          return false;
        }
        if (p != null &&
            (!board.pawns.has(f) || !promotionSquares.contains(t))) {
          return false;
        }
        final legalMoves = _legalMovesOf(f);
        return legalMoves.has(t);
    }
  }

  /// Gets the legal moves for that [Square].
  SquareSet legalMovesOf(Square square) {
    return _legalMovesOf(square);
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
        return [...previousValue, ...squares];
      }))
        s: _legalMovesOf(s, context: context)
    });
  }

  /// Plays a move and returns the updated [Position].
  ///
  /// Throws a [PlayException] if the move is not legal.
  Position<T> play(Move move) {
    if (isLegal(move)) {
      return playUnchecked(move);
    } else {
      throw PlayException('Invalid move $move');
    }
  }

  /// Plays a move without checking if the move is legal and returns the
  /// updated [Position].
  Position<T> playUnchecked(Move move) {
    switch (move) {
      case NormalMove(
          from: final from,
          to: final to,
          promotion: final promotion
        ):
        final piece = board.pieceAt(from);
        if (piece == null) {
          return copyWith();
        }
        Board newBoard = board.removePieceAt(from);
        final newPiece =
            promotion != null ? piece.copyWith(role: promotion) : piece;
        newBoard = newBoard.setPieceAt(to, newPiece);

        // Update armies if we're moving on or off of colored squares
        var controlledArmies = (p1Controlled, p2Controlled);
        if (from.color != null) {
          controlledArmies = _removeControlledArmy(from.color!);
        }
        if (to.color != null) {
          controlledArmies = _addControlledArmy(to.color!);
        }

        return copyWith(
          ply: ply + 1,
          board: newBoard,
          turn: turn.opposite,
          p1Controlled: controlledArmies.$1,
          p2Controlled: controlledArmies.$2,
        );
    }
  }

  (ISet<PieceColor>, ISet<PieceColor>) _removeControlledArmy(PieceColor color) {
    switch (turn) {
      case Side.player1:
        return (p1Controlled.remove(color), p2Controlled);
      case Side.player2:
        return (p1Controlled, p2Controlled.remove(color));
    }
  }

  (ISet<PieceColor>, ISet<PieceColor>) _addControlledArmy(PieceColor color) {
    switch (turn) {
      case Side.player1:
        return (p1Controlled.add(color), p2Controlled);
      case Side.player2:
        return (p1Controlled, p2Controlled.add(color));
    }
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

    // Cannot move onto a square of its own color
    final ownColorSquares = _getOwnColoredSquares(piece);
    pseudo = pseudo.diff(ownColorSquares);

    // Only one square of each color may be occupied at a time.
    pseudo = pseudo.diff(_occupiedColoredSquares());

    // Include colors that aren't controlled because we cannot attack those pieces
    pseudo = pseudo.diff(board.exclude(_sideColors(turn.opposite)));
    return pseudo;
  }

  // Create a mask of colored squares we cannot move onto.
  SquareSet _occupiedColoredSquares() {
    final coloredSquares = [
      SquareSet.whiteSquares,
      SquareSet.blackSquares,
      SquareSet.ashSquares,
      SquareSet.slateSquares,
      SquareSet.cyanSquares,
      SquareSet.greenSquares,
      SquareSet.navySquares,
      SquareSet.orangeSquares,
      SquareSet.pinkSquares,
      SquareSet.redSquares,
      SquareSet.violetSquares,
      SquareSet.yellowSquares,
    ];
    return coloredSquares.fold(
        SquareSet.empty,
        (prev, mask) => (mask & board.occupied).lsb() != null
            ? (prev | (mask.diff(board.occupied)))
            : prev);
  }

  SquareSet _getOwnColoredSquares(Piece piece) {
    return switch (piece.color) {
      PieceColor.white => SquareSet.whiteSquares,
      PieceColor.black => SquareSet.blackSquares,
      PieceColor.ash => SquareSet.ashSquares,
      PieceColor.slate => SquareSet.slateSquares,
      PieceColor.cyan => SquareSet.cyanSquares,
      PieceColor.green => SquareSet.greenSquares,
      PieceColor.navy => SquareSet.navySquares,
      PieceColor.orange => SquareSet.orangeSquares,
      PieceColor.pink => SquareSet.pinkSquares,
      PieceColor.red => SquareSet.redSquares,
      PieceColor.violet => SquareSet.violetSquares,
      PieceColor.yellow => SquareSet.yellowSquares,
    };
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
    required super.ply,
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
      ply: setup.ply,
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
    int? ply,
  }) {
    return SovereignChess(
      board: board ?? this.board,
      turn: turn ?? this.turn,
      p1Owned: p1Owned ?? this.p1Owned,
      p1Controlled: p1Controlled ?? this.p1Controlled,
      p2Owned: p2Owned ?? this.p2Owned,
      p2Controlled: p2Controlled ?? this.p2Controlled,
      ply: ply ?? this.ply,
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
