import 'package:flutter/widgets.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import './geometry.dart';

/// Board aware [Positioned] widget.
///
/// Use to position things, such as a [PieceWidget] or [SquareHighlight] on the
/// board.
///
/// It must be a descendant of a [Stack] since it's a wrapper over [Positioned].
class PositionedSquare extends StatelessWidget with ChessboardGeometry {
  const PositionedSquare({
    super.key,
    required this.child,
    required this.size,
    required this.square,
    this.childSize = 1,
  });

  final Widget child;

  /// The total size of the board.
  @override
  final double size;

  final Square square;

  /// The width/height of the child in number of squares.
  ///
  /// i.e. if `childSize` is 4, then the child would span a 4x4 section of the
  /// board.
  final int childSize;

  @override
  Widget build(BuildContext context) {
    final offset = squareOffset(square);
    return Positioned(
      width: squareSize * childSize,
      height: squareSize * childSize,
      left: offset.dx,
      top: offset.dy,
      child: child,
    );
  }
}
