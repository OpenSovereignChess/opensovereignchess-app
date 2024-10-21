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

  static const empty = SquareSet(0, 0, 0, 0, 0, 0, 0, 0);

  _SquareSetSegment _squareToSegment(Square square) {
    int index = square ~/ intSize;
    int offset = square % intSize;
    int data = _get(index);
    return _SquareSetSegment(
      index: index,
      offset: offset,
      data: data,
    );
  }

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

  /// Returns true if the [SquareSet] contains the given [square].
  bool has(Square square) {
    final s = _squareToSegment(square);
    return s.data & (1 << s.offset) != 0;
  }

  /// Returns a new [SquareSet] with the given [square] added.
  SquareSet withSquare(Square square) {
    final s = _squareToSegment(square);
    return SquareSet(
      s.index == 7 ? h | (1 << s.offset) : h,
      s.index == 6 ? g | (1 << s.offset) : g,
      s.index == 5 ? f | (1 << s.offset) : f,
      s.index == 4 ? e | (1 << s.offset) : e,
      s.index == 3 ? d | (1 << s.offset) : d,
      s.index == 2 ? c | (1 << s.offset) : c,
      s.index == 1 ? b | (1 << s.offset) : b,
      s.index == 0 ? a | (1 << s.offset) : a,
    );
  }
}
