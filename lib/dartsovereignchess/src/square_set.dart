import 'package:flutter/widgets.dart';
import './models.dart';

const intSize = 32;

/// A segment of a [SquareSet] representing part of the board.
@immutable
class _SquareSetSegment {
  const _SquareSetSegment({
    required this.data,
    required this.index,
    required this.offset,
  });

  /// The 32-bit integer representing 32 squares of the board.
  final int data;

  /// The index of the segment in the SquareSet.
  final int index;

  /// The bit representing the square in this segment.
  final int offset;
}

/// A finite set of all squares on a chessboard.
///
/// Dart uses 32-bit integers when compiled for web:
///   https://dart.dev/guides/language/numbers#bitwise-operations.
/// Our board has 256 squares.  To emulate a normal chess bitboard,
/// we will stitch together 8 32-bit integers to get our 256 squares,
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

  /// The 8 32-bit integers representing the parts of our board.
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

  Iterable<Square> _iterateSquares() sync* {
    // TODO: Iterate through the rest of the segments.
    int bitboard = a;
    while (bitboard != 0) {
      final square = Square(_getFirstBit(bitboard)!);
      bitboard ^= 1 << square!;
      yield square;
    }
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
