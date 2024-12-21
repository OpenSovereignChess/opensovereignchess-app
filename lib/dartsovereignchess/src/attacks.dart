import './models.dart';
import './square_set.dart';
import './debug.dart';

/// Gets squares attacked or defended by a king on [Square].
SquareSet kingAttacks(Square square) {
  return _kingAttacks[square];
}

/// Gets squares attacked or defended by a knight on [Square].
SquareSet knightAttacks(Square square) {
  return _knightAttacks[square];
}

/// Gets squares attacked or defended by a pawn on [Square].
SquareSet pawnAttacks(Square square) {
  return _pawnAttacks[square];
}

/// Gets squares attacked or defended by a bishop on [Square], given `occupied`
/// squares.
SquareSet bishopAttacks(Square square, SquareSet occupied) {
  // https://www.chessprogramming.org/Classical_Approach
  final nwRay =
      _computeRayAttack(_northwestRange[square], occupied, _northwestRange);
  final neRay =
      _computeRayAttack(_northeastRange[square], occupied, _northeastRange);
  final seRay = _computeRayAttack(
      _southeastRange[square], occupied, _northeastRange, true);
  final swRay = _computeRayAttack(
      _southwestRange[square], occupied, _northwestRange, true);
  return nwRay | neRay | seRay | swRay;
}

/// Gets squares attacked or defended by a rook on [Square], given `occupied`
/// squares.
SquareSet rookAttacks(Square square, SquareSet occupied) {
  final northRay =
      _computeRayAttack(_northRange[square], occupied, _northRange);
  final eastRay = _computeRayAttack(_eastRange[square], occupied, _eastRange);
  final southRay =
      _computeRayAttack(_southRange[square], occupied, _northRange, true);
  final westRay = _computeWestRayAttack(_westRange[square], occupied);
  return northRay | eastRay | southRay | westRay;
}

/// Gets squares attacked or defended by a queen on [Square], given `occupied`
/// squares.
SquareSet queenAttacks(Square square, SquareSet occupied) {
  return bishopAttacks(square, occupied) ^ rookAttacks(square, occupied);
}

/// Gets all squares of the rank, file or diagonal with the two squares
/// `a` and `b`, or an empty set if they are not aligned.
///
/// Only considers rays of length 9, as that is as far as a sliding piece
/// can move.
SquareSet ray(Square a, Square b) {
  final other = SquareSet.fromSquare(b);
  if (_northRange[a].isIntersected(other)) {
    return _northRange[a].withSquare(a);
  }
  if (_northeastRange[a].isIntersected(other)) {
    return _northeastRange[a].withSquare(a);
  }
  if (_eastRange[a].isIntersected(other)) {
    return _eastRange[a].withSquare(a);
  }
  if (_southeastRange[a].isIntersected(other)) {
    return _southeastRange[a].withSquare(a);
  }
  if (_southRange[a].isIntersected(other)) {
    return _southRange[a].withSquare(a);
  }
  if (_southwestRange[a].isIntersected(other)) {
    return _southwestRange[a].withSquare(a);
  }
  if (_westRange[a].isIntersected(other)) {
    return _westRange[a].withSquare(a);
  }
  if (_northwestRange[a].isIntersected(other)) {
    return _northwestRange[a].withSquare(a);
  }
  return SquareSet.empty;
}

/// Gets all squares between `a` and `b` (bounds not included), or an empty set
/// if they are not on the same rank, file or diagonal.
SquareSet between(Square a, Square b) => ray(a, b)
    .intersect(SquareSet.full.shl(a).xor(SquareSet.full.shl(b)))
    .withoutFirst();

SquareSet _computeRange(Square square, List<int> deltas) {
  SquareSet range = SquareSet.empty;
  for (final delta in deltas) {
    final sq = square + delta;
    if (0 <= sq &&
        sq < Square.values.length &&
        (square.file - Square(sq).file).abs() <= 2) {
      range = range.withSquare(Square(sq));
    }
  }
  return range;
}

List<T> _tabulate<T>(T Function(Square square) f) {
  final List<T> table = [];
  for (final square in Square.values) {
    table.insert(square, f(square));
  }
  return table;
}

final _kingAttacks =
    _tabulate((sq) => _computeRange(sq, [-17, -16, -15, -1, 1, 15, 16, 17]));

final _knightAttacks =
    _tabulate((sq) => _computeRange(sq, [-33, -31, -18, -14, 14, 18, 31, 33]));

final _pawnAttacks = _tabulate((sq) {
  switch (sq.rank) {
    case < Rank.ninth:
      return _computeRange(sq, [15, 17]);
    default:
      return _computeRange(sq, [-17, -15]);
  }
});

final _northRange = _tabulate((sq) {
  return SquareSet.northRay.shl(sq);
});

final _eastRange = _tabulate((sq) {
  SquareSet mask = _rankMask[sq.rank];
  return SquareSet.eastRay.shl(sq) & mask;
});

final _southRange = _tabulate((sq) {
  final shift = Square.values.last - sq;
  return SquareSet.southRay.shr(shift);
});

final _westRange = _tabulate((sq) {
  SquareSet mask = _rankMask[sq.rank];
  final shift = Square.values.last - sq;
  return SquareSet.westRay.shr(shift) & mask;
});

final _northwestRange = _tabulate((sq) {
  SquareSet mask = SquareSet.empty;
  for (final (file, fileMask) in _fileMask.indexed) {
    if (file < sq.file) {
      mask = mask | fileMask;
    }
  }
  return sq <= Square.i1
      ? SquareSet.northwestRay.shr(Square.i1 - sq) & mask
      : SquareSet.northwestRay.shl(sq - Square.i1) & mask;
});

final _northeastRange = _tabulate((sq) {
  SquareSet mask = SquareSet.empty;
  for (final (file, fileMask) in _fileMask.indexed) {
    if (file > sq.file) {
      mask = mask | fileMask;
    }
  }
  return SquareSet.northeastRay.shl(sq) & mask;
});

final _southeastRange = _tabulate((sq) {
  SquareSet mask = SquareSet.empty;
  for (final (file, fileMask) in _fileMask.indexed) {
    if (file > sq.file) {
      mask = mask | fileMask;
    }
  }
  return sq <= Square.h16
      ? SquareSet.southeastRay.shr(Square.h16 - sq) & mask
      : SquareSet.southeastRay.shl(sq - Square.h16) & mask;
});

final _southwestRange = _tabulate((sq) {
  SquareSet mask = SquareSet.empty;
  for (final (file, fileMask) in _fileMask.indexed) {
    if (file < sq.file) {
      mask = mask | fileMask;
    }
  }
  final shift = Square.values.last - sq;
  return SquareSet.southwestRay.shr(shift) & mask;
});

// `ranges` should be the northern version, when `reverse` is true, i.e.
// - for southeast rays, `_northeastRange`
// - for southwest rays, `_northwestRange`
SquareSet _computeRayAttack(
    SquareSet ray, SquareSet occupied, List<SquareSet> ranges,
    [bool reverse = false]) {
  final _ray = reverse ? ray.flipVertical() : ray;
  final _occupied = reverse ? occupied.flipVertical() : occupied;
  final intersection = _occupied & _ray;
  final lsb = intersection.lsb();
  final blocked = (lsb != null ? ranges[lsb] : SquareSet.empty) & _ray;
  final result = _ray ^ blocked;
  return reverse ? result.flipVertical() : result;
}

SquareSet _computeWestRayAttack(SquareSet ray, SquareSet occupied) {
  final _ray = ray.mirrorHorizontal();
  final _occupied = occupied.mirrorHorizontal();
  final intersection = _occupied & _ray;
  final lsb = intersection.lsb();
  final blocked = (lsb != null ? _eastRange[lsb] : SquareSet.empty) & _ray;
  final result = _ray ^ blocked;
  return result.mirrorHorizontal();
}

final _rankMask = <SquareSet>[
  SquareSet.firstRankMask,
  SquareSet.secondRankMask,
  SquareSet.thirdRankMask,
  SquareSet.fourthRankMask,
  SquareSet.fifthRankMask,
  SquareSet.sixthRankMask,
  SquareSet.seventhRankMask,
  SquareSet.eigthRankMask,
  SquareSet.ninthRankMask,
  SquareSet.tenthRankMask,
  SquareSet.eleventhRankMask,
  SquareSet.twelvthRankMask,
  SquareSet.thirteenthRankMask,
  SquareSet.fourteenthRankMask,
  SquareSet.fifteenthRankMask,
  SquareSet.sixteenthRankMask,
];

final _fileMask = <SquareSet>[
  SquareSet.aFileMask,
  SquareSet.bFileMask,
  SquareSet.cFileMask,
  SquareSet.dFileMask,
  SquareSet.eFileMask,
  SquareSet.fFileMask,
  SquareSet.gFileMask,
  SquareSet.hFileMask,
  SquareSet.iFileMask,
  SquareSet.jFileMask,
  SquareSet.kFileMask,
  SquareSet.lFileMask,
  SquareSet.mFileMask,
  SquareSet.nFileMask,
  SquareSet.oFileMask,
  SquareSet.pFileMask,
];
