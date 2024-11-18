import 'package:flutter/widgets.dart';
import './models.dart';
import './debug.dart';

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

  static const empty = SquareSet(0, 0, 0, 0, 0, 0, 0, 0);
  static const diagonal = SquareSet(0x80004000, 0x20001000, 0x8000400,
      0x2000100, 0x800040, 0x200010, 0x80004, 0x20001);
  static const antidiagonal = SquareSet(0x10002, 0x40008, 0x100020, 0x400080,
      0x1000200, 0x4000800, 0x10002000, 0x40008000);

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

  /// Returns a new [SquareSet] with the [other] squares removed from this set.
  SquareSet minus(SquareSet other) => _minus(other);
  SquareSet operator -(SquareSet other) => _minus(other);

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

  /// Returns true if the [SquareSet] contains the given [square].
  bool has(Square square) {
    final (index, offset) = _squareToKey(square);
    final integer = _get(index);
    return integer & (1 << offset) != 0;
  }

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

  SquareSet _minus(SquareSet other) {
    return SquareSet(
      h - other.h,
      g - other.g,
      f - other.f,
      e - other.e,
      d - other.d,
      c - other.c,
      b - other.b,
      a - other.a,
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
