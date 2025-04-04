import 'package:flutter/widgets.dart';
import './models.dart';

const intSize = 32;
const rowSize = 16;

/// A finite set of all squares on a chessboard.
///
/// Dart uses 32-bit integers when compiled for web:
///   https://dart.dev/guides/language/numbers#bitwise-operations.
/// Our board has 256 squares.  To emulate a normal chess bitboard,
/// we will stitch together 8 32 bit integers to get our 256 squares,
/// using a little-endian rank-file mapping.
/// See also [Square].
///
/// The set operations are implemented as bitwise operations on the integers,
/// with some overhead to keep the 8 integers behaving as one massive
/// 256 bit integer.
@immutable
class SquareSet {
  const SquareSet(
    this.h,
    this.g,
    this.f,
    this.e,
    this.d,
    this.c,
    this.b,
    this.a,
  );

  /// The 8 32 bit integers representing the parts of our board.
  ///
  /// `a` represents squares a1, b1 ... o2, p2.
  /// `b` represents squares a3, b3 ... o4, p4.
  /// etc.
  final int a;
  final int b;
  final int c;
  final int d;
  final int e;
  final int f;
  final int g;
  final int h;

  /// Creates a [SquareSet] with a single [Square].
  factory SquareSet.fromSquare(Square square) {
    final (index, offset) = _squareToKey(square);
    return SquareSet(
      index == 7 ? (1 << offset) : 0,
      index == 6 ? (1 << offset) : 0,
      index == 5 ? (1 << offset) : 0,
      index == 4 ? (1 << offset) : 0,
      index == 3 ? (1 << offset) : 0,
      index == 2 ? (1 << offset) : 0,
      index == 1 ? (1 << offset) : 0,
      index == 0 ? (1 << offset) : 0,
    );
  }

  /// Creates a [SquareSet] from several [Square]s.
  factory SquareSet.fromSquares(Iterable<Square> squares) {
    return squares
        .map((square) => SquareSet.fromSquare(square))
        .fold(SquareSet.empty, (left, right) => left | right);
  }

  /// Creates a [SquareSet] containing all squares of the given [Rank].
  factory SquareSet.fromRank(Rank rank) => switch (rank) {
        Rank.first => firstRankMask,
        Rank.second => secondRankMask,
        Rank.third => thirdRankMask,
        Rank.fourth => fourthRankMask,
        Rank.fifth => fifthRankMask,
        Rank.sixth => sixthRankMask,
        Rank.seventh => seventhRankMask,
        Rank.eighth => eigthRankMask,
        Rank.ninth => ninthRankMask,
        Rank.tenth => tenthRankMask,
        Rank.eleventh => eleventhRankMask,
        Rank.twelfth => twelfthRankMask,
        Rank.thirteenth => thirteenthRankMask,
        Rank.fourteenth => fourteenthRankMask,
        Rank.fifteenth => fifteenthRankMask,
        Rank.sixteenth => sixteenthRankMask,
        _ => throw Exception('invalid rank'),
      };

  /// Creates a [SquareSet] containing all squares of the given [File].
  factory SquareSet.fromFile(File file) => switch (file) {
        File.a => aFileMask,
        File.b => bFileMask,
        File.c => cFileMask,
        File.d => dFileMask,
        File.e => eFileMask,
        File.f => fFileMask,
        File.g => gFileMask,
        File.h => hFileMask,
        File.i => iFileMask,
        File.j => jFileMask,
        File.k => kFileMask,
        File.l => lFileMask,
        File.m => mFileMask,
        File.n => nFileMask,
        File.o => oFileMask,
        File.p => pFileMask,
        _ => throw Exception('invalid file'),
      };

  /// Create a [SquareSet] containing all squares of the given backrank of [Side].
  ///
  /// If player2 chooses to play as white on the first turn, then player2 will
  /// become player1. This way we know that player 1's backrank is always the
  /// first rank.
  factory SquareSet.backrankOf(Side side) => switch (side) {
        Side.player1 => SquareSet.firstRankMask,
        Side.player2 => SquareSet.sixteenthRankMask,
      };

  static const empty = SquareSet(0, 0, 0, 0, 0, 0, 0, 0);
  static const full = SquareSet(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

  // North or east rays start from a1
  // South or west rays start from p16
  // Northwest ray starts from i1
  // Southeast ray starts from h16
  static const northRay =
      SquareSet(0, 0, 0, 1, 0x10001, 0x10001, 0x10001, 0x10000);
  static const eastRay = SquareSet(0, 0, 0, 0, 0, 0, 0, 0x1FE);
  static const southRay = SquareSet(
      0x8000, 0x80008000, 0x80008000, 0x80008000, 0x80000000, 0, 0, 0);
  static const westRay = SquareSet(0x7F800000, 0, 0, 0, 0, 0, 0, 0);
  static const northwestRay =
      SquareSet(0, 0, 0, 1, 0x20004, 0x80010, 0x200040, 0x800000);
  static const northeastRay =
      SquareSet(0, 0, 0, 0x100, 0x800040, 0x200010, 0x80004, 0x20000);
  static const southeastRay =
      SquareSet(0x100, 0x2000400, 0x8001000, 0x20004000, 0x80000000, 0, 0, 0);
  static const southwestRay =
      SquareSet(0x4000, 0x20001000, 0x8000400, 0x2000100, 0x800000, 0, 0, 0);

  // Rank masks
  static const firstRankMask = SquareSet(0, 0, 0, 0, 0, 0, 0, 0xFFFF);
  static const secondRankMask = SquareSet(0, 0, 0, 0, 0, 0, 0, 0xFFFF0000);
  static const thirdRankMask = SquareSet(0, 0, 0, 0, 0, 0, 0xFFFF, 0);
  static const fourthRankMask = SquareSet(0, 0, 0, 0, 0, 0, 0xFFFF0000, 0);
  static const fifthRankMask = SquareSet(0, 0, 0, 0, 0, 0xFFFF, 0, 0);
  static const sixthRankMask = SquareSet(0, 0, 0, 0, 0, 0xFFFF0000, 0, 0);
  static const seventhRankMask = SquareSet(0, 0, 0, 0, 0xFFFF, 0, 0, 0);
  static const eigthRankMask = SquareSet(0, 0, 0, 0, 0xFFFF0000, 0, 0, 0);
  static const ninthRankMask = SquareSet(0, 0, 0, 0xFFFF, 0, 0, 0, 0);
  static const tenthRankMask = SquareSet(0, 0, 0, 0xFFFF0000, 0, 0, 0, 0);
  static const eleventhRankMask = SquareSet(0, 0, 0xFFFF, 0, 0, 0, 0, 0);
  static const twelfthRankMask = SquareSet(0, 0, 0xFFFF0000, 0, 0, 0, 0, 0);
  static const thirteenthRankMask = SquareSet(0, 0xFFFF, 0, 0, 0, 0, 0, 0);
  static const fourteenthRankMask = SquareSet(0, 0xFFFF0000, 0, 0, 0, 0, 0, 0);
  static const fifteenthRankMask = SquareSet(0xFFFF, 0, 0, 0, 0, 0, 0, 0);
  static const sixteenthRankMask = SquareSet(0xFFFF0000, 0, 0, 0, 0, 0, 0, 0);

  // File masks
  static const aFileMask = SquareSet(
      0x10001, 0x10001, 0x10001, 0x10001, 0x10001, 0x10001, 0x10001, 0x10001);
  static const bFileMask = SquareSet(
      0x20002, 0x20002, 0x20002, 0x20002, 0x20002, 0x20002, 0x20002, 0x20002);
  static const cFileMask = SquareSet(
      0x40004, 0x40004, 0x40004, 0x40004, 0x40004, 0x40004, 0x40004, 0x40004);
  static const dFileMask = SquareSet(
      0x80008, 0x80008, 0x80008, 0x80008, 0x80008, 0x80008, 0x80008, 0x80008);
  static const eFileMask = SquareSet(0x100010, 0x100010, 0x100010, 0x100010,
      0x100010, 0x100010, 0x100010, 0x100010);
  static const fFileMask = SquareSet(0x200020, 0x200020, 0x200020, 0x200020,
      0x200020, 0x200020, 0x200020, 0x200020);
  static const gFileMask = SquareSet(0x400040, 0x400040, 0x400040, 0x400040,
      0x400040, 0x400040, 0x400040, 0x400040);
  static const hFileMask = SquareSet(0x800080, 0x800080, 0x800080, 0x800080,
      0x800080, 0x800080, 0x800080, 0x800080);
  static const iFileMask = SquareSet(0x1000100, 0x1000100, 0x1000100, 0x1000100,
      0x1000100, 0x1000100, 0x1000100, 0x1000100);
  static const jFileMask = SquareSet(0x2000200, 0x2000200, 0x2000200, 0x2000200,
      0x2000200, 0x2000200, 0x2000200, 0x2000200);
  static const kFileMask = SquareSet(0x4000400, 0x4000400, 0x4000400, 0x4000400,
      0x4000400, 0x4000400, 0x4000400, 0x4000400);
  static const lFileMask = SquareSet(0x8000800, 0x8000800, 0x8000800, 0x8000800,
      0x8000800, 0x8000800, 0x8000800, 0x8000800);
  static const mFileMask = SquareSet(0x10001000, 0x10001000, 0x10001000,
      0x10001000, 0x10001000, 0x10001000, 0x10001000, 0x10001000);
  static const nFileMask = SquareSet(0x20002000, 0x20002000, 0x20002000,
      0x20002000, 0x20002000, 0x20002000, 0x20002000, 0x20002000);
  static const oFileMask = SquareSet(0x40004000, 0x40004000, 0x40004000,
      0x40004000, 0x40004000, 0x40004000, 0x40004000, 0x40004000);
  static const pFileMask = SquareSet(0x80008000, 0x80008000, 0x80008000,
      0x80008000, 0x80008000, 0x80008000, 0x80008000, 0x80008000);

  // Colored square masks
  static const whiteSquares = SquareSet(0, 0, 0, 0x80, 0x1000000, 0, 0, 0);
  static const blackSquares = SquareSet(0, 0, 0, 0x100, 0x800000, 0, 0, 0);
  static const ashSquares = SquareSet(0, 0, 0, 0x2000000, 0x40, 0, 0, 0);
  static const slateSquares = SquareSet(0, 0, 0, 0x400000, 0x200, 0, 0, 0);
  static const cyanSquares = SquareSet(0, 0, 0, 0x400, 0x200000, 0, 0, 0);
  static const greenSquares = SquareSet(0, 0, 0x400, 0, 0, 0x200000, 0, 0);
  static const navySquares = SquareSet(0, 0, 0x8000000, 0, 0, 0x10, 0, 0);
  static const orangeSquares = SquareSet(0, 0, 0, 0x20, 0x4000000, 0, 0, 0);
  static const pinkSquares = SquareSet(0, 0, 0x80, 0, 0, 0x1000000, 0, 0);
  static const redSquares = SquareSet(0, 0, 0x100000, 0, 0, 0x800, 0, 0);
  static const violetSquares = SquareSet(0, 0, 0x100, 0, 0, 0x800000, 0, 0);
  static const yellowSquares = SquareSet(0, 0, 0x20, 0, 0, 0x4000000, 0, 0);

  // Starting rook positions for castling
  static const castlingRooks = SquareSet(0x28140000, 0, 0, 0, 0, 0, 0, 0x2814);

  // Pawn promotion box mask
  static const promotionBox = SquareSet(0, 0, 0, 0x3C00240, 0x24003C0, 0, 0, 0);

  /// Bitwise right shift
  SquareSet shr(int shift) {
    if (shift >= Square.values.length) {
      return SquareSet.empty;
    }
    if (shift > 0) {
      // Circular shift, but onto the next integer instead of the same integer
      if (shift > intSize) {
        // Naive implementation: don't shift more than 32 bits at a time,
        // or else we have to do a more complicated algorithm.
        final rounds = shift ~/ intSize;
        SquareSet result = this;
        for (var i = 1; i <= rounds; i++) {
          result = result._shr(intSize);
        }
        final remainder = shift % intSize;
        if (remainder > 0) {
          result = result._shr(remainder);
        }
        return result;
      } else {
        return _shr(shift);
      }
    }
    return this;
  }

  /// Bitwise left shift
  SquareSet shl(int shift) {
    if (shift >= Square.values.length) {
      return SquareSet.empty;
    }
    if (shift > 0) {
      // Circular shift, but onto the next integer instead of the same integer
      if (shift > intSize) {
        // Naive implementation: don't shift more than 32 bits at a time,
        // or else we have to do a more complicated algorithm.
        final rounds = shift ~/ intSize;
        SquareSet result = this;
        for (var i = 1; i <= rounds; i++) {
          result = result._shl(intSize);
        }
        final remainder = shift % intSize;
        if (remainder > 0) {
          result = result._shl(remainder);
        }
        return result;
      } else {
        return _shl(shift);
      }
    }
    return this;
  }

  /// Returns a new [SquareSet] with a bitwise XOR of this set and [other].
  SquareSet xor(SquareSet other) => _xor(other);
  SquareSet operator ^(SquareSet other) => _xor(other);

  /// Returns a new [SquareSet] with the squares that are in either this set or [other].
  SquareSet union(SquareSet other) => _union(other);
  SquareSet operator |(SquareSet other) => _union(other);

  /// Returns a new [SquareSet] with the squares that are in both this set and [other].
  SquareSet intersect(SquareSet other) => _intersect(other);
  SquareSet operator &(SquareSet other) => _intersect(other);

  /// Returns the set difference of this set and [other].
  SquareSet diff(SquareSet other) => _diff(other);

  /// Flips the set vertically.
  SquareSet flipVertical() {
    return SquareSet(
      ((a >>> rowSize) | (a << rowSize)).toUnsigned(intSize),
      ((b >>> rowSize) | (b << rowSize)).toUnsigned(intSize),
      ((c >>> rowSize) | (c << rowSize)).toUnsigned(intSize),
      ((d >>> rowSize) | (d << rowSize)).toUnsigned(intSize),
      ((e >>> rowSize) | (e << rowSize)).toUnsigned(intSize),
      ((f >>> rowSize) | (f << rowSize)).toUnsigned(intSize),
      ((g >>> rowSize) | (g << rowSize)).toUnsigned(intSize),
      ((h >>> rowSize) | (h << rowSize)).toUnsigned(intSize),
    );
  }

  /// Flips the set horizontally.
  SquareSet mirrorHorizontal() {
    return SquareSet(
      _mirrorHorizontal(h).toUnsigned(intSize),
      _mirrorHorizontal(g).toUnsigned(intSize),
      _mirrorHorizontal(f).toUnsigned(intSize),
      _mirrorHorizontal(e).toUnsigned(intSize),
      _mirrorHorizontal(d).toUnsigned(intSize),
      _mirrorHorizontal(c).toUnsigned(intSize),
      _mirrorHorizontal(b).toUnsigned(intSize),
      _mirrorHorizontal(a).toUnsigned(intSize),
    );
  }

  // https://www.chessprogramming.org/Flipping_Mirroring_and_Rotating#Horizontal
  int _mirrorHorizontal(int val) {
    final k1 = 0x55555555;
    final k2 = 0x33333333;
    final k4 = 0xF0F0F0F;
    final k8 = 0xFF00FF;
    int x = val;
    x = ((x >> 1) & k1) | ((x & k1) << 1);
    x = ((x >> 2) & k2) | ((x & k2) << 2);
    x = ((x >> 4) & k4) | ((x & k4) << 4);
    x = ((x >> 8) & k8) | ((x & k8) << 8);
    return x;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SquareSet &&
            other.a == a &&
            other.b == b &&
            other.c == c &&
            other.d == d &&
            other.e == e &&
            other.f == f &&
            other.g == g &&
            other.h == h;
  }

  @override
  int get hashCode => Object.hash(a, b, c, d, e, f, g, h);

  /// Method to retrieve a specific integer representing part of the board.
  ///
  /// Allows us to access the integers by index.  We cannot store them in a
  /// list because we want constant SquareSet values.
  int _get(int i) {
    return switch (i) {
      0 => a,
      1 => b,
      2 => c,
      3 => d,
      4 => e,
      5 => f,
      6 => g,
      7 => h,
      _ => throw Exception('invalid index'),
    };
  }

  /// Returns the squares in the set as an iterable.
  Iterable<Square> get squares => _iterateSquares();

  /// Returns the number of squares in the set.
  int get size => squares.length;

  /// Returns true if the set is empty.
  bool get isEmpty => lsb() == null;

  /// Returns true if the set is not empty.
  bool get isNotEmpty => lsb() != null;

  /// Returns the first square in the set, or null if the set is empty.
  Square? get first => squares.isEmpty ? null : squares.first;

  /// Returns the last square in the set, or null if the set is empty.
  Square? get last => squares.isEmpty ? null : squares.last;

  /// Returns true if the set contains more than one square.
  bool get moreThanOne => isNotEmpty && size > 1;

  /// Returns square if it is single, otherwise returns null.
  Square? get singleSquare => moreThanOne ? null : lsb();

  /// Returns true if the [SquareSet] contains the given [square].
  bool has(Square square) {
    final (index, offset) = _squareToKey(square);
    final integer = _get(index);
    return integer & (1 << offset) != 0;
  }

  /// Returns true if the square set has any square in the [other] square set.
  bool isIntersected(SquareSet other) => intersect(other).isNotEmpty;

  /// Returns a new [SquareSet] with the given [square] added.
  SquareSet withSquare(Square square) {
    final (index, offset) = _squareToKey(square);
    return SquareSet(
      index == 7 ? h | (1 << offset) : h,
      index == 6 ? g | (1 << offset) : g,
      index == 5 ? f | (1 << offset) : f,
      index == 4 ? e | (1 << offset) : e,
      index == 3 ? d | (1 << offset) : d,
      index == 2 ? c | (1 << offset) : c,
      index == 1 ? b | (1 << offset) : b,
      index == 0 ? a | (1 << offset) : a,
    );
  }

  /// Returns a new [SquareSet] with the given [square] removed.
  SquareSet withoutSquare(Square square) {
    final (index, offset) = _squareToKey(square);
    return SquareSet(
      index == 7 ? h & ~(1 << offset) : h,
      index == 6 ? g & ~(1 << offset) : g,
      index == 5 ? f & ~(1 << offset) : f,
      index == 4 ? e & ~(1 << offset) : e,
      index == 3 ? d & ~(1 << offset) : d,
      index == 2 ? c & ~(1 << offset) : c,
      index == 1 ? b & ~(1 << offset) : b,
      index == 0 ? a & ~(1 << offset) : a,
    );
  }

  /// Returns the least significant bit as a [Square].
  Square? lsb() {
    final it = _iterateSquares();
    return it.isEmpty ? null : it.first;
  }

  /// Returns a new [SquareSet] with its first [Square] removed.
  SquareSet withoutFirst() {
    final f = lsb();
    return f != null ? withoutSquare(f) : empty;
  }

  Iterable<int> _iterateSegments() sync* {
    yield a;
    yield b;
    yield c;
    yield d;
    yield e;
    yield f;
    yield g;
    yield h;
  }

  Iterable<Square> _iterateSquares() sync* {
    for (final (index, segment) in _iterateSegments().indexed) {
      int bitboard = segment;
      int offset = index * intSize;
      while (bitboard != 0) {
        final square = _getFirstBit(bitboard);
        bitboard ^= 1 << square!;
        yield Square(square + offset);
      }
    }
  }

  SquareSet _shr(int shift) {
    assert(shift >= 0 && shift <= intSize,
        'cannot shift more than 32 bits at a time');
    return SquareSet(
      (h >>> shift).toUnsigned(intSize),
      (g >>> shift | h << (intSize - shift)).toUnsigned(intSize),
      (f >>> shift | g << (intSize - shift)).toUnsigned(intSize),
      (e >>> shift | f << (intSize - shift)).toUnsigned(intSize),
      (d >>> shift | e << (intSize - shift)).toUnsigned(intSize),
      (c >>> shift | d << (intSize - shift)).toUnsigned(intSize),
      (b >>> shift | c << (intSize - shift)).toUnsigned(intSize),
      (a >>> shift | b << (intSize - shift)).toUnsigned(intSize),
    );
  }

  SquareSet _shl(int shift) {
    assert(shift >= 0 && shift <= intSize,
        'cannot shift more than 32 bits at a time');
    return SquareSet(
      (h << shift | g >> (intSize - shift)).toUnsigned(intSize),
      (g << shift | f >> (intSize - shift)).toUnsigned(intSize),
      (f << shift | e >> (intSize - shift)).toUnsigned(intSize),
      (e << shift | d >> (intSize - shift)).toUnsigned(intSize),
      (d << shift | c >> (intSize - shift)).toUnsigned(intSize),
      (c << shift | b >> (intSize - shift)).toUnsigned(intSize),
      (b << shift | a >> (intSize - shift)).toUnsigned(intSize),
      (a << shift).toUnsigned(intSize),
    );
  }

  SquareSet _xor(SquareSet other) {
    return SquareSet(
      h ^ other.h,
      g ^ other.g,
      f ^ other.f,
      e ^ other.e,
      d ^ other.d,
      c ^ other.c,
      b ^ other.b,
      a ^ other.a,
    );
  }

  SquareSet _union(SquareSet other) {
    return SquareSet(
      h | other.h,
      g | other.g,
      f | other.f,
      e | other.e,
      d | other.d,
      c | other.c,
      b | other.b,
      a | other.a,
    );
  }

  SquareSet _intersect(SquareSet other) {
    return SquareSet(
      h & other.h,
      g & other.g,
      f & other.f,
      e & other.e,
      d & other.d,
      c & other.c,
      b & other.b,
      a & other.a,
    );
  }

  SquareSet _diff(SquareSet other) {
    return SquareSet(
      h & ~other.h,
      g & ~other.g,
      f & ~other.f,
      e & ~other.e,
      d & ~other.d,
      c & ~other.c,
      b & ~other.b,
      a & ~other.a,
    );
  }

  int? _getFirstBit(int bitboard) {
    final ntz = _ntz32(bitboard);
    return ntz >= 0 && ntz < intSize ? ntz : null;
  }
}

(int, int) _squareToKey(Square square) {
  int index = square ~/ intSize;
  int offset = square % intSize;
  return (index, offset);
}

// from https://gist.github.com/jtmcdole/297434f327077dbfe5fb19da3b4ef5be
// Returns the number of trailing zeros in a 32bit unsigned integer.
int _ntz32(int x) {
  assert(x < 0x100000000, "only 32bit numbers supported");
  return _ntzLut32[(x & -x) % 37];
}

const _ntzLut32 = [
  32, 0, 1, 26, 2, 23, 27, 0, //
  3, 16, 24, 30, 28, 11, 0, 13,
  4, 7, 17, 0, 25, 22, 31, 15,
  29, 10, 12, 6, 0, 21, 14, 9,
  5, 20, 8, 19, 18
];
