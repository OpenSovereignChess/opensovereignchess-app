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
  });

  final Widget child;

  @override
  final double size;

  final Square square;

  @override
  Widget build(BuildContext context) {
    final offset = squareOffset(square);
    return Positioned(
      width: squareSize,
      height: squareSize,
      left: offset.dx,
      top: offset.dy,
      child: child,
    );
  }
}
