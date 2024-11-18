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
  SquareSet attacks = _northwestRange[square] |
      _northeastRange[square] |
      _southeastRange[square] |
      _southwestRange[square];
  return attacks;
  //print(humanReadableSquareSet(_southwestRange[Square.e5]!));
  //print('_hyperbola for _diagRange');
  //print(humanReadableSquareSet(_hyperbola(bit, _diagRange[square], occupied)));
  //return _hyperbola(bit, _diagRange[square], occupied) ^
  //    _hyperbola(bit, _antiDiagRange[square], occupied);
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

final _diagRange = _tabulate((sq) {
  final shift = File.values.length * (sq.rank - sq.file);
  return (shift >= 0
          ? SquareSet.diagonal.shl(shift)
          : SquareSet.diagonal.shr(-shift))
      .withoutSquare(sq);
});

final _antiDiagRange = _tabulate((sq) {
  final shift = File.values.length * (sq.rank + sq.file - File.values.last);
  return (shift >= 0
          ? SquareSet.antidiagonal.shl(shift)
          : SquareSet.antidiagonal.shr(-shift))
      .withoutSquare(sq);
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

SquareSet _hyperbola(SquareSet bit, SquareSet range, SquareSet occupied) {
  // https://www.chessprogramming.org/Classical_Approach
  //SquareSet blockers = occupied & range;
  // Find least significant bit of blockers
  // Get the range from the LSB (should be direction-specific, e.g. NorthWest)
  // range XOR bitboard from previous step

  SquareSet forward = occupied & range;
  //print('_hyperbola ${bit.squares}');
  //print('bit');
  //print(humanReadableSquareSet(bit));
  //print('range');
  //print(humanReadableSquareSet(range));
  //print('occupied');
  //print(humanReadableSquareSet(occupied));
  //print('forward');
  //print(humanReadableSquareSet(forward));
  SquareSet reverse =
      forward.flipVertical(); // Assumes no more than 1 bit per rank
  //print('reverse');
  //print(humanReadableSquareSet(reverse));
  forward = forward - bit;
  //print('forward - bit');
  //print(humanReadableSquareSet(forward));
  reverse = reverse - bit.flipVertical();
  //print('reverse - bit');
  //print(humanReadableSquareSet(reverse));
  //print('output');
  //print(humanReadableSquareSet((forward ^ reverse.flipVertical()) & range));
  return (forward ^ reverse.flipVertical()) & range;
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
