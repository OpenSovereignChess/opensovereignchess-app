import 'package:flutter/material.dart';
import 'package:opensovereignchess_app/src/dartsovereignchess/dartsovereignchess.dart';

import '../board_settings.dart';
import './positioned_square.dart';

/// A Sovereign Chess board widget.
///
/// This widget can be used to display a static board or a full interactive board.
class Chessboard extends StatefulWidget {
  /// Creates a new chessboard widget with interactive pieces.
  ///
  /// Provide a [game] state to enable interaction with the board.
  /// The [fen] string should be updated when the position changes.
  const Chessboard({
    super.key,
    required this.size,
    this.settings = const ChessboardSettings(),
  });

  /// Size of the board in logical pixels.
  final double size;

  /// Settings that control the theme and behavior of the board.
  final ChessboardSettings settings;

  @override
  State<Chessboard> createState() => _BoardState();
}

class _BoardState extends State<Chessboard> {
  /// Pieces on the board.
  //Pieces pieces = {};

  /// Currently selected square.
  Square? selected = Square.p16;

  @override
  Widget build(BuildContext context) {
    final background = widget.settings.colorScheme.background;

    final List<Widget> highlightedBackground = [
      SizedBox.square(
        key: const ValueKey('board-background'),
        dimension: widget.size,
        child: background,
      ),
      if (selected != null)
        PositionedSquare(
          key: ValueKey('${selected!.name}-selected'),
          size: widget.size,
          square: selected!,
          child: Text('A'),
        ),
    ];

    final List<Widget> objects = [];

    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...highlightedBackground,
          ...objects,
        ],
      ),
    );
  }
}
