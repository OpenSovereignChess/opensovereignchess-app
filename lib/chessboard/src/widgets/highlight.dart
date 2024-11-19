import 'package:flutter/widgets.dart';

/// A square highlight on the board.
///
/// This is useful to indicate interesting squares on the board, such as the last
/// move, a check, or a selected piece.
class SquareHighlight extends StatelessWidget {
  const SquareHighlight({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

/// A widget that displays a valid move destination highlight.
///
/// This is used to indicate where a piece can move to on the board.
class ValidMoveHighlight extends StatelessWidget {
  const ValidMoveHighlight({
    super.key,
    required this.color,
    required this.size,
    this.occupied = false,
  });

  final Color color;
  final double size;
  final bool occupied;

  @override
  Widget build(BuildContext context) {
    return occupied
        ? OccupiedValidMoveHighlight(color: color, size: size)
        : SizedBox.square(
            dimension: size,
            child: Padding(
              padding: EdgeInsets.all(size / 3),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
  }
}

/// A widget that displays an occupied move destination highlight.
///
/// Occupied move destinations are used to indicate where a piece can move to
/// on a square that is already occupied by a piece.
class OccupiedValidMoveHighlight extends StatelessWidget {
  const OccupiedValidMoveHighlight({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _OccupiedMoveDestPainter(color),
      ),
    );
  }
}

class _OccupiedMoveDestPainter extends CustomPainter {
  _OccupiedMoveDestPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width / 5
      ..style = PaintingStyle.stroke;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width - (size.width / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(_OccupiedMoveDestPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
