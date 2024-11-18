import './models.dart';
import './square_set.dart';
import './debug.dart';

/// Gets squares attacked or defended by a king on [Square].
SquareSet kingAttacks(Square square) {
  return _kingAttacks[square];
}

/// Gets squares attacked or defended by a bishop on [Square], given `occupied`
/// squares.
SquareSet bishopAttacks(Square square, SquareSet occupied) {
  final bit = SquareSet.fromSquare(square);
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

// ranges should be the flipped version
SquareSet _computeRayAttack(
    SquareSet ray, SquareSet occupied, List<SquareSet> ranges,
    [bool reverse = false]) {
  final _ray = reverse ? ray.flipVertical() : ray;
  final _occupied = reverse ? occupied.flipVertical() : occupied;
  final intersection = _occupied & _ray;
  final lsb = intersection.lsb();
  final blocked = (lsb != null ? ranges[lsb] : SquareSet.empty) & _ray;
  //print('blocked');
  //print(humanReadableSquareSet(blocked));
  final result = _ray ^ blocked;
  return reverse ? result.flipVertical() : result;
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
