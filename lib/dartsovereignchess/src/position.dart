import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './army_manager.dart';
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
    required this.armyManager,
    required this.ply,
  });

  /// Piece positions on the board.
  final Board board;

  /// Side to move.
  final Side turn;

  /// Manager for each player's owned and controlled armies.
  final ArmyManager armyManager;

  // Current half-move number.
  final int ply;

  /// The [Rule] of this position.
  Rule get rule;

  /// Creates a copy of this position with some fields changed.
  Position<T> copyWith({
    Board? board,
    Side? turn,
    ArmyManager? armyManager,
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
      armyManager: armyManager,
      castlingRights: SquareSet.empty,
      ply: ply,
    ).fen;
  }

  /// Tests if the king is in check.
  bool get isCheck {
    final king = board.kingOf(armyManager.colorOf(turn));
    return king != null && checkers.isNotEmpty;
  }

  /// Tests for checkmate.
  bool get isCheckmate => checkers.isNotEmpty && !hasSomeLegalMoves;

  /// [PieceColor] of the king in check, if any.
  PieceColor? get checkedKingColor =>
      isCheck ? armyManager.colorOf(turn) : null;

  /// Tests if the position has at least one legal move.
  bool get hasSomeLegalMoves {
    final context = _makeContext();
    for (final square in board.byColors(armyManager.colorsOf(turn)).squares) {
      if (_legalMovesOf(square, context: context).isNotEmpty) {
        return true;
      }
    }
    return false;
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
      for (final s in armyManager.colorsOf(turn).fold<List<Square>>([],
          (previousValue, color) {
        final squares = board.byColor(color).squares;
        return [...previousValue, ...squares];
      }))
        s: _legalMovesOf(s, context: context)
    });
  }

  /// Square set of pieces giving check.
  SquareSet get checkers {
    final king = board.kingOf(armyManager.colorOf(turn));
    return king != null ? kingAttackers(king, turn.opposite) : SquareSet.empty;
  }

  /// Attacks that a king on `square` would have to deal with.
  SquareSet kingAttackers(Square square, Side attacker, {SquareSet? occupied}) {
    SquareSet attackers = board
        .attacksTo(square, armyManager.colorsOf(attacker), occupied: occupied);
    // Attackers cannot jump to a square of their own color
    attackers = attackers.squares.fold(attackers, (prevVal, sq) {
      final piece = board.pieceAt(sq);
      return piece!.color == square.color ? prevVal.withoutSquare(sq) : prevVal;
    });
    return attackers;
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
        ArmyManager newArmyManager = armyManager;

        // Remove existing king if we're promoting to a king
        if (promotion == Role.king) {
          final kingSquare = newBoard.kingOf(armyManager.colorOf(turn));
          newBoard = newBoard.removePieceAt(kingSquare!);
          newArmyManager = newArmyManager.setOwnedColor(turn, piece.color);
        }

        final newPiece =
            promotion != null ? piece.copyWith(role: promotion) : piece;
        newBoard = newBoard.setPieceAt(to, newPiece);

        // Update armies if we're moving on or off of colored squares
        if (from.color != null) {
          newArmyManager =
              newArmyManager.removeControlledArmy(turn, from.color!);
        }
        if (to.color != null) {
          newArmyManager = newArmyManager.addControlledArmy(turn, to.color!);
        }

        return copyWith(
          ply: ply + 1,
          board: newBoard,
          turn: turn.opposite,
          armyManager: newArmyManager,
        );
    }
  }

  /// Gets the legal moves for that [Square].
  ///
  /// Optionally pass a [_Context] of the position, to optimize performance when
  /// calling this method several times.
  SquareSet _legalMovesOf(Square square, {_Context? context}) {
    final ctx = context ?? _makeContext();
    final piece = board.pieceAt(square);
    if (piece == null || !armyManager.colorsOf(turn).contains(piece.color)) {
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
    final ownColorSquares = board.coloredSquaresOf(piece.color);
    pseudo = pseudo.diff(ownColorSquares);

    // Only one square of each color may be occupied at a time.
    // But we allow a piece that is currently on a colored square to move
    // to the other square of the same color.
    pseudo = pseudo
        .diff(_occupiedColoredSquares(board.occupied.withoutSquare(square)));

    // Include colors that aren't controlled because we cannot attack those pieces
    pseudo = pseudo.diff(board.exclude(armyManager.colorsOf(turn.opposite)));

    if (ctx.king != null) {
      if (piece.role == Role.king) {
        final occ = board.occupied.withoutSquare(square);
        for (final to in pseudo.squares) {
          if (kingAttackers(to, turn.opposite, occupied: occ).isNotEmpty) {
            pseudo = pseudo.withoutSquare(to);
          }
        }
        return pseudo;
      }

      if (ctx.checkers.isNotEmpty) {
        final checker = ctx.checkers.singleSquare;
        if (checker == null) {
          return SquareSet.empty;
        }
        // When king is in check, only include moves that could block the check
        pseudo = pseudo & between(checker, ctx.king!).withSquare(checker);
      }

      // TODO: Blocker should be able to move toward the sniper too,
      // not just toward the king.
      if (ctx.blockers.has(square)) {
        pseudo = pseudo & ray(square, ctx.king!);
      }
    }
    return pseudo;
  }

  // Create a mask of colored squares we cannot move onto.
  SquareSet _occupiedColoredSquares(SquareSet occupied) {
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
        (prev, mask) => (mask & occupied).lsb() != null
            ? (prev | (mask.diff(occupied)))
            : prev);
  }

  _Context _makeContext() {
    final king = board.kingOf(armyManager.colorOf(turn));
    return _Context(
      king: king,
      blockers: _sliderBlockers(king!),
      checkers: checkers,
    );
  }

  SquareSet _sliderBlockers(Square king) {
    final snipers = rookAttacks(king, SquareSet.empty)
        .intersect(board.rooksAndQueens)
        .union(bishopAttacks(king, SquareSet.empty)
            .intersect(board.bishopsAndQueens))
        .intersect(board.byColors(armyManager.colorsOf(turn.opposite)));
    SquareSet blockers = SquareSet.empty;
    for (final sniper in snipers.squares) {
      final b = between(king, sniper) & board.occupied;
      if (!b.moreThanOne) {
        blockers = blockers | b;
      }
    }
    return blockers;
  }
}

/// A standard Sovereign Chess position.
@immutable
class SovereignChess extends Position<SovereignChess> {
  const SovereignChess({
    required super.board,
    required super.turn,
    required super.armyManager,
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
      armyManager: setup.armyManager,
      ply: setup.ply,
    );
    return pos;
  }

  @override
  SovereignChess copyWith({
    Board? board,
    Side? turn,
    ArmyManager? armyManager,
    int? ply,
  }) {
    return SovereignChess(
      board: board ?? this.board,
      turn: turn ?? this.turn,
      armyManager: armyManager ?? this.armyManager,
      ply: ply ?? this.ply,
    );
  }
}

@immutable
class _Context {
  const _Context({
    required this.king,
    required this.blockers,
    required this.checkers,
  });

  final Square? king;
  final SquareSet blockers;
  final SquareSet checkers;

  _Context copyWith({
    Square? king,
    SquareSet? blockers,
    SquareSet? checkers,
  }) {
    return _Context(
      king: king,
      blockers: blockers ?? this.blockers,
      checkers: checkers ?? this.checkers,
    );
  }
}
