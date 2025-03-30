import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './attacks.dart';
import './board.dart';
import './castles.dart';
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
    required this.castles,
    required this.ply,
  });

  /// Piece positions on the board.
  final Board board;

  /// Side to move.
  final Side turn;

  /// Castling paths and unmoved rooks.
  final Castles castles;

  // Current half-move number.
  final int ply;

  /// The [Rule] of this position.
  Rule get rule;

  /// Creates a copy of this position with some fields changed.
  Position<T> copyWith({
    Board? board,
    Side? turn,
    Castles? castles,
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
      castlingRights: castles.castlingRights,
      ply: ply,
    ).fen;
  }

  /// Tests if the king is in check.
  bool get isCheck {
    final king = board.kingOf(turn);
    return king != null && checkers.isNotEmpty;
  }

  /// Tests for checkmate.
  bool get isCheckmate => checkers.isNotEmpty && !hasSomeLegalMoves;

  /// [PieceColor] of the king in check, if any.
  PieceColor? get checkedKingColor => isCheck ? board.ownedColorOf(turn) : null;

  /// Returns whether the given [Side] can defect.
  bool canDefect(Side side) => board.controlledColorsOf(side).isNotEmpty;

  PieceColor get ownedColor => board.ownedColorOf(turn);

  PieceColor ownedColorOf(Side side) => board.ownedColorOf(side);

  ISet<PieceColor> get controlledColors => board.controlledColorsOf(turn);

  /// Tests if the position has at least one legal move.
  bool get hasSomeLegalMoves {
    final context = _makeContext();
    for (final square in board.bySide(turn).squares) {
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
      for (final s in board.bySide(turn).squares)
        s: _legalMovesOf(s, context: context)
    });
  }

  /// Square set of pieces giving check.
  SquareSet get checkers {
    final king = board.kingOf(turn);
    return king != null ? kingAttackers(king, turn.opposite) : SquareSet.empty;
  }

  /// Attacks that a king on `square` would have to deal with.
  SquareSet kingAttackers(Square square, Side attacker, {SquareSet? occupied}) {
    SquareSet attackers = board.attacksTo(square, attacker, occupied: occupied);
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

        // Remove existing king if we're promoting to a king
        if (promotion == Role.king) {
          final kingSquare = newBoard.kingOf(turn);
          newBoard = newBoard.removePieceAt(kingSquare!);
          newBoard = newBoard.setOwnedColor(turn, piece.color);
        }

        final newPiece =
            promotion != null ? piece.copyWith(role: promotion) : piece;
        newBoard = newBoard.setPieceAt(to, newPiece);

        // Update armies if we're moving on or off of colored squares
        if (from.color != null) {
          newBoard = newBoard.removeControlledColor(from.color!);
        }
        if (to.color != null) {
          newBoard = newBoard.addControlledColor(newPiece.color, to.color!);
        }

        // Update castling rights when:
        // - the king moves
        // - a rook moves
        // - when we promote to a king
        Castles newCastles = castles;
        if (newPiece.role == Role.king) {
          newCastles = newCastles.discardSide(turn);
        } else if (newPiece.role == Role.rook) {
          newCastles = newCastles.discardRookAt(from);
        }

        return copyWith(
          ply: ply + 1,
          board: newBoard,
          turn: turn.opposite,
          castles: newCastles,
        );
    }
  }

  /// Defect to [PieceColor].
  Position<T> defect(PieceColor color) {
    // PieceColor must be controlled by the player
    if (!board.colorControlledBy(turn, color)) {
      return copyWith();
    }
    final king = board.kingOf(turn);
    if (king == null) {
      return copyWith();
    }
    final newKing = Piece(
      role: Role.king,
      color: color,
    );
    Board newBoard = board.setPieceAt(king, newKing);
    newBoard = newBoard.setOwnedColor(turn, color);
    return copyWith(
      board: newBoard,
      turn: turn.opposite,
      ply: ply + 1,
    );
  }

  /// Gets all squares with pieces that lead to the control of [PieceColor].
  SquareSet _squaresControllingColor(PieceColor color,
      [Set<PieceColor>? visited]) {
    visited ??= <PieceColor>{};

    if (visited.contains(color)) {
      return SquareSet.empty;
    }

    visited.add(color);

    SquareSet result = board.coloredSquaresOf(color) & board.occupied;
    Square? occupiedSquare =
        result.lsb(); // Only one sqaure can be occupied at a time
    if (occupiedSquare != null) {
      final piece = board.pieceAt(occupiedSquare);
      if (piece != null) {
        result = result | _squaresControllingColor(piece.color, visited);
      }
    }
    return result;
  }

  /// Gets the legal moves for that [Square].
  ///
  /// Optionally pass a [_Context] of the position, to optimize performance when
  /// calling this method several times.
  SquareSet _legalMovesOf(Square square, {_Context? context}) {
    final ctx = context ?? _makeContext();
    final piece = board.pieceAt(square);
    if (piece == null || !board.colorBelongsTo(turn, piece.color)) {
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

    // Cannot attack our own pieces as well as neutral pieces (pieces not
    // controlled by either player).
    pseudo = pseudo.diff(board.occupied.diff(board.bySide(turn.opposite)));

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
        // Ways to escape check:
        // - Move king
        // - Block checker
        // - Capture checker
        // - Control checker by capturing piece that leads to its control
        // - Move king to a square of the same color as the checker (i.e. the owned color of the opponent)
        // - Promote owned or controlled pawn to a king
        final checker = ctx.checkers.singleSquare;

        if (checker == null) {
          // If there are multiple checkers, only the king can move except for special cases
          return SquareSet.empty;
        }

        // When king is in check, only include moves that could block the check
        //pseudo = pseudo & between(checker, ctx.king!).withSquare(checker);

        // Allow capture that leads to control of the checker
        final checkerPiece = board.pieceAt(checker);
        final coloredSquaresOfChecker =
            _squaresControllingColor(checkerPiece!.color);
        pseudo = pseudo &
            ((coloredSquaresOfChecker & board.bySide(turn.opposite)) |
                between(checker, ctx.king!).withSquare(checker));
      }

      // TODO: Blocker should be able to move toward the sniper too,
      // not just toward the king.
      if (ctx.blockers.has(square)) {
        pseudo = pseudo & ray(square, ctx.king!);
      }
    }
    return pseudo;
  }

  /// Returns whether we can castle in this position.
  bool get canCastle => legalCastlingMoves.entries
      .map((entry) => entry.value.isNotEmpty)
      .any((value) => value);

  /// Gets all the legal castling moves of this position.
  ///
  /// Returns a [SquareSet] of all the legal castling moves for each [Square].
  IMap<Square, SquareSet> get legalCastlingMoves {
    if (board.kingOf(turn) == null ||
        castles.castlingRights.isEmpty ||
        isCheck) {
      return IMap({});
    }
    Map<Square, SquareSet> castlingMoves = {};
    SquareSet moves = SquareSet.empty;
    for (final entry in castles.paths[turn]!.entries) {
      final path = entry.value;
      // Cannot be any pieces in the path
      if (path.intersect(board.occupied).isNotEmpty) {
        continue;
      }
      // Cannot move through check, but can move until check
      final orientedSquares = entry.key == CastlingSide.king
          ? path.squares
          : path.squares.toList().reversed;
      final unattackedPath = orientedSquares
          .takeWhile((s) => kingAttackers(s, turn.opposite).isEmpty);
      moves = moves | SquareSet.fromSquares(unattackedPath);
    }
    castlingMoves[board.kingOf(turn)!] = moves;
    return castlingMoves.lock;
  }

  /// Plays a castle and returns the updated [Position].
  ///
  /// Throws a [PlayException] if the move is not legal.
  Position<T> playCastle(Move move) {
    if (isLegalCastle(move)) {
      return playCastleUnchecked(move);
    } else {
      throw PlayException('Invalid move $move');
    }
  }

  /// Tests a castle move for legality.
  bool isLegalCastle(Move move) {
    switch (move) {
      case NormalMove(from: final f, to: final t, promotion: final p):
        final piece = board.pieceAt(f);
        if (piece == null || piece.role != Role.king) {
          return false;
        }
        if (p != null) {
          return false;
        }
        final legalMoves = legalCastlingMoves[board.kingOf(turn)!];
        return legalMoves!.has(t);
    }
  }

  /// Plays a castle move without checking if the move is legal and returns the
  /// updated [Position].
  Position<T> playCastleUnchecked(Move move) {
    switch (move) {
      case NormalMove(
          from: final from,
          to: final to,
        ):
        final piece = board.pieceAt(from);
        if (piece == null) {
          return copyWith();
        }

        // Move king
        Board newBoard = board.removePieceAt(from);
        newBoard = newBoard.setPieceAt(to, piece);

        // Move rook
        final cs = _castlingSideOf(move);
        final rookSquare = castles.rookOf(turn, cs)!;
        final rook = newBoard.pieceAt(rookSquare);
        final newRook = to + (cs == CastlingSide.king ? -1 : 1);
        newBoard = newBoard.removePieceAt(rookSquare);
        newBoard = newBoard.setPieceAt(newRook as Square, rook!);

        return copyWith(
          ply: ply + 1,
          board: newBoard,
          turn: turn.opposite,
          castles: castles.discardSide(turn),
        );
    }
  }

  /// Returns the [CastlingSide] of a castle move.
  ///
  /// Assumes the move is a castle move.
  CastlingSide _castlingSideOf(Move move) {
    switch (move) {
      case NormalMove(from: final f, to: final t):
        return t - f > 0 ? CastlingSide.king : CastlingSide.queen;
    }
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
    final king = board.kingOf(turn);
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
        .intersect(board.bySide(turn.opposite));
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
    required super.castles,
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
      castles: Castles.fromSetup(setup),
      ply: setup.ply,
    );
    return pos;
  }

  @override
  SovereignChess copyWith({
    Board? board,
    Side? turn,
    Castles? castles,
    int? ply,
  }) {
    return SovereignChess(
      board: board ?? this.board,
      turn: turn ?? this.turn,
      castles: castles ?? this.castles,
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
