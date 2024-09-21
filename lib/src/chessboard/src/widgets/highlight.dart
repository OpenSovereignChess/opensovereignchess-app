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
