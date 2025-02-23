import 'package:meta/meta.dart';

import 'attacks.dart';
import 'models.dart';
import 'setup.dart';
import 'square_set.dart';
import 'debug.dart';

/// Represents the castling rights of a game.
@immutable
abstract class Castles {
  /// Creates a new [Castles] instance.
  const factory Castles({
    required SquareSet castlingRights,
    Square? whiteRookQueenSide,
    Square? whiteRookKingSide,
    Square? blackRookQueenSide,
    Square? blackRookKingSide,
    required SquareSet whitePathQueenSide,
    required SquareSet whitePathKingSide,
    required SquareSet blackPathQueenSide,
    required SquareSet blackPathKingSide,
  }) = _Castles;

  const Castles._({
    required this.castlingRights,
    Square? whiteRookQueenSide,
    Square? whiteRookKingSide,
    Square? blackRookQueenSide,
    Square? blackRookKingSide,
    required SquareSet whitePathQueenSide,
    required SquareSet whitePathKingSide,
    required SquareSet blackPathQueenSide,
    required SquareSet blackPathKingSide,
  })  : _whiteRookQueenSide = whiteRookQueenSide,
        _whiteRookKingSide = whiteRookKingSide,
        _blackRookQueenSide = blackRookQueenSide,
        _blackRookKingSide = blackRookKingSide,
        _whitePathQueenSide = whitePathQueenSide,
        _whitePathKingSide = whitePathKingSide,
        _blackPathQueenSide = blackPathQueenSide,
        _blackPathKingSide = blackPathKingSide;

  /// SquareSet of rooks that have not moved yet.
  final SquareSet castlingRights;

  final Square? _whiteRookQueenSide;
  final Square? _whiteRookKingSide;
  final Square? _blackRookQueenSide;
  final Square? _blackRookKingSide;
  final SquareSet _whitePathQueenSide;
  final SquareSet _whitePathKingSide;
  final SquareSet _blackPathQueenSide;
  final SquareSet _blackPathKingSide;

  static const standard = Castles(
    castlingRights: SquareSet.castlingRooks,
    whiteRookQueenSide: Square.e1,
    whiteRookKingSide: Square.l1,
    blackRookQueenSide: Square.e16,
    blackRookKingSide: Square.l16,
    whitePathQueenSide: SquareSet(0, 0, 0, 0, 0, 0, 0, 0xE0),
    whitePathKingSide: SquareSet(0, 0, 0, 0, 0, 0, 0, 0x600),
    blackPathQueenSide: SquareSet(0xE00000, 0, 0, 0, 0, 0, 0, 0),
    blackPathKingSide: SquareSet(0x6000000, 0, 0, 0, 0, 0, 0, 0),
  );

  static const empty = Castles(
    castlingRights: SquareSet.empty,
    whitePathQueenSide: SquareSet.empty,
    whitePathKingSide: SquareSet.empty,
    blackPathQueenSide: SquareSet.empty,
    blackPathKingSide: SquareSet.empty,
  );

  /// Creates a [Castles] instance from a [Setup].
  ///
  /// In a standard game setup, there are initially four rooks with castling
  /// rights, but there is only one rook on each side that you can castle with
  /// at any given time. So disregard the outer rooks until the inner rooks
  /// relinquish their castling rights.
  factory Castles.fromSetup(Setup setup) {
    Castles castles = Castles.empty;
    final rooks = setup.castlingRights & setup.board.rooks;
    castles = castles.copyWith(castlingRights: rooks);
    for (final side in Side.values) {
      final backrank = SquareSet.backrankOf(side);
      // Store the king square for each side in Castles.  Add new properties for this ai!
      final king = setup.board.kingOf(side);
      if (king == null || !backrank.has(king)) continue;
      final backrankRooks = rooks & setup.board.bySide(side) & backrank;
      final queenSideRook = _getClosestRook(CastlingSide.queen, king, backrankRooks);
      final kingSideRook = _getClosestRook(CastlingSide.king, king, backrankRooks);

      if (queenSideRook != null) {
        castles = castles._add(side, CastlingSide.queen, king, queenSideRook);
      }
      if (kingSideRook != null) {
        castles = castles._add(side, CastlingSide.king, king, kingSideRook);
      }
    }
    return castles;
  }

  /// Gets rooks positions by side and castling side.
  BySide<ByCastlingSide<Square?>> get rooksPositions {
    return BySide({
      Side.player1: ByCastlingSide({
        CastlingSide.queen: _whiteRookQueenSide,
        CastlingSide.king: _whiteRookKingSide,
      }),
      Side.player2: ByCastlingSide({
        CastlingSide.queen: _blackRookQueenSide,
        CastlingSide.king: _blackRookKingSide,
      }),
    });
  }

  /// Gets ByCastlingSiderooks paths by side and castling side.
  BySide<ByCastlingSide<SquareSet>> get paths {
    return BySide({
      Side.player1: ByCastlingSide({
        CastlingSide.queen: _whitePathQueenSide,
        CastlingSide.king: _whitePathKingSide,
      }),
      Side.player2: ByCastlingSide({
        CastlingSide.queen: _blackPathQueenSide,
        CastlingSide.king: _blackPathKingSide,
      }),
    });
  }

  /// Gets the rook [Square] by side and castling side.
  Square? rookOf(Side side, CastlingSide cs) => switch (side) {
        Side.player1 => switch (cs) {
            CastlingSide.queen => _whiteRookQueenSide,
            CastlingSide.king => _whiteRookKingSide,
          },
        Side.player2 => switch (cs) {
            CastlingSide.queen => _blackRookQueenSide,
            CastlingSide.king => _blackRookKingSide,
          },
      };

  /// Gets the squares that need to be empty so that castling is possible
  /// on the given side.
  ///
  /// We're assuming the player still has the required castling rigths.
  SquareSet pathOf(Side side, CastlingSide cs) => switch (side) {
        Side.player1 => switch (cs) {
            CastlingSide.queen => _whitePathQueenSide,
            CastlingSide.king => _whitePathKingSide,
          },
        Side.player2 => switch (cs) {
            CastlingSide.queen => _blackPathQueenSide,
            CastlingSide.king => _blackPathKingSide,
          },
      };

  /// Returns a new [Castles] instance with the given rook discarded.
  Castles discardRookAt(Square square) {
    // When we discard a rook, we should fall back to any remaining rooks
    return copyWith(
      castlingRights: castlingRights.withoutSquare(square),
      whiteRookQueenSide:
          _whiteRookQueenSide == square ? null : _whiteRookQueenSide,
      whiteRookKingSide:
          _whiteRookKingSide == square ? null : _whiteRookKingSide,
      blackRookQueenSide:
          _blackRookQueenSide == square ? null : _blackRookQueenSide,
      blackRookKingSide:
          _blackRookKingSide == square ? null : _blackRookKingSide,
    );
  }

  /// Returns a new [Castles] instance with the given side discarded.
  Castles discardSide(Side side) {
    return copyWith(
      castlingRights: castlingRights.diff(SquareSet.backrankOf(side)),
      whiteRookQueenSide: side == Side.player1 ? null : _whiteRookQueenSide,
      whiteRookKingSide: side == Side.player1 ? null : _whiteRookKingSide,
      blackRookQueenSide: side == Side.player2 ? null : _blackRookQueenSide,
      blackRookKingSide: side == Side.player2 ? null : _blackRookKingSide,
    );
  }

  Castles _add(Side side, CastlingSide cs, Square king, Square rook) {
    //final kingTo = kingCastlesTo(side, cs);
    //final rookTo = rookCastlesTo(side, cs);
    final path = between(rook, king);
        //.withSquare(rookTo)
        //.union(between(king, kingTo).withSquare(kingTo))
        //.withoutSquare(king)
        //.withoutSquare(rook);
    return copyWith(
      castlingRights: castlingRights.withSquare(rook),
      whiteRookQueenSide: side == Side.player1 && cs == CastlingSide.queen
          ? rook
          : _whiteRookQueenSide,
      whiteRookKingSide: side == Side.player1 && cs == CastlingSide.king
          ? rook
          : _whiteRookKingSide,
      blackRookQueenSide: side == Side.player2 && cs == CastlingSide.queen
          ? rook
          : _blackRookQueenSide,
      blackRookKingSide: side == Side.player2 && cs == CastlingSide.king
          ? rook
          : _blackRookKingSide,
      whitePathQueenSide:
          side == Side.player1 && cs == CastlingSide.queen ? path : null,
      whitePathKingSide:
          side == Side.player1 && cs == CastlingSide.king ? path : null,
      blackPathQueenSide:
          side == Side.player2 && cs == CastlingSide.queen ? path : null,
      blackPathKingSide:
          side == Side.player2 && cs == CastlingSide.king ? path : null,
    );
  }

  @override
  String toString() {
    return '''Castles(
castlingRights:
${humanReadableSquareSet(castlingRights)})
_whiteRookQueenSide: ${_whiteRookQueenSide?.name ?? 'null'}
_whiteRookKingSide: ${_whiteRookKingSide?.name ?? 'null'}
_blackRookQueenSide: ${_blackRookQueenSide?.name ?? 'null'}
_blackRookKingSide: ${_blackRookKingSide?.name ?? 'null'}
_whitePathQueenSide:
${humanReadableSquareSet(_whitePathQueenSide)})
_whitePathKingSide:
${humanReadableSquareSet(_whitePathKingSide)})
_blackPathQueenSide:
${humanReadableSquareSet(_blackPathQueenSide)})
_blackPathKingSide:
${humanReadableSquareSet(_blackPathKingSide)})
''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Castles &&
          other.castlingRights == castlingRights &&
          other._whiteRookQueenSide == _whiteRookQueenSide &&
          other._whiteRookKingSide == _whiteRookKingSide &&
          other._blackRookQueenSide == _blackRookQueenSide &&
          other._blackRookKingSide == _blackRookKingSide &&
          other._whitePathQueenSide == _whitePathQueenSide &&
          other._whitePathKingSide == _whitePathKingSide &&
          other._blackPathQueenSide == _blackPathQueenSide &&
          other._blackPathKingSide == _blackPathKingSide;

  @override
  int get hashCode => Object.hash(
      castlingRights,
      _whiteRookQueenSide,
      _whiteRookKingSide,
      _blackRookQueenSide,
      _blackRookKingSide,
      _whitePathQueenSide,
      _whitePathKingSide,
      _blackPathQueenSide,
      _blackPathKingSide);

  Castles copyWith({
    SquareSet? castlingRights,
    Square? whiteRookQueenSide,
    Square? whiteRookKingSide,
    Square? blackRookQueenSide,
    Square? blackRookKingSide,
    SquareSet? whitePathQueenSide,
    SquareSet? whitePathKingSide,
    SquareSet? blackPathQueenSide,
    SquareSet? blackPathKingSide,
  });
}

///// Returns the square the rook moves to when castling.
//Square rookCastlesTo(Side side, CastlingSide cs) => switch (side) {
//      Side.player1 => switch (cs) {
//          CastlingSide.queen => Square.d1,
//          CastlingSide.king => Square.f1,
//        },
//      Side.player2 => switch (cs) {
//          CastlingSide.queen => Square.d8,
//          CastlingSide.king => Square.f8,
//        },
//    };
//
///// Returns the square the king moves to when castling.
//Square kingCastlesTo(Side side, CastlingSide cs) => switch (side) {
//      Side.player1 => switch (cs) {
//          CastlingSide.queen => Square.c1,
//          CastlingSide.king => Square.g1,
//        },
//      Side.player2 => switch (cs) {
//          CastlingSide.queen => Square.c8,
//          CastlingSide.king => Square.g8,
//        },
//    };

class _Castles extends Castles {
  const _Castles({
    required super.castlingRights,
    super.whiteRookQueenSide,
    super.whiteRookKingSide,
    super.blackRookQueenSide,
    super.blackRookKingSide,
    required super.whitePathQueenSide,
    required super.whitePathKingSide,
    required super.blackPathQueenSide,
    required super.blackPathKingSide,
  }) : super._();

  @override
  Castles copyWith({
    SquareSet? castlingRights,
    Object? whiteRookQueenSide = _uniqueObjectInstance,
    Object? whiteRookKingSide = _uniqueObjectInstance,
    Object? blackRookQueenSide = _uniqueObjectInstance,
    Object? blackRookKingSide = _uniqueObjectInstance,
    SquareSet? whitePathQueenSide,
    SquareSet? whitePathKingSide,
    SquareSet? blackPathQueenSide,
    SquareSet? blackPathKingSide,
  }) {
    return _Castles(
      castlingRights: castlingRights ?? this.castlingRights,
      whiteRookQueenSide: whiteRookQueenSide == _uniqueObjectInstance
          ? _whiteRookQueenSide
          : whiteRookQueenSide as Square?,
      whiteRookKingSide: whiteRookKingSide == _uniqueObjectInstance
          ? _whiteRookKingSide
          : whiteRookKingSide as Square?,
      blackRookQueenSide: blackRookQueenSide == _uniqueObjectInstance
          ? _blackRookQueenSide
          : blackRookQueenSide as Square?,
      blackRookKingSide: blackRookKingSide == _uniqueObjectInstance
          ? _blackRookKingSide
          : blackRookKingSide as Square?,
      whitePathQueenSide: whitePathQueenSide ?? _whitePathQueenSide,
      whitePathKingSide: whitePathKingSide ?? _whitePathKingSide,
      blackPathQueenSide: blackPathQueenSide ?? _blackPathQueenSide,
      blackPathKingSide: blackPathKingSide ?? _blackPathKingSide,
    );
  }
}

/// Unique object to use as a sentinel value in copyWith methods.
const _uniqueObjectInstance = Object();

/// Return the closest rook to the king on the given [CastlingSide].
Square? _getClosestRook(CastlingSide cs, Square king, SquareSet rooks) {
  Square? maxRook;
  for (final _rook in rooks.squares) {
    if (cs == CastlingSide.queen) {
      if (_rook < king) {
        maxRook = _rook;
      } else {
        return maxRook;
      }
    } else {
      if (_rook > king) {
        return _rook;
      }
    }
  }
  return null;
}
