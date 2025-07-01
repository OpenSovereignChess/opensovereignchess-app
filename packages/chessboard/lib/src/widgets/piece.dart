import 'package:flutter/widgets.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';

import '../models.dart';

/// Widget that displays a chess piece.
class PieceWidget extends StatelessWidget {
  const PieceWidget({
    super.key,
    required this.piece,
    required this.size,
    required this.pieceAssets,
  });

  /// Specifies the role and color of the piece.
  final Piece piece;

  /// Size of the board square the piece will occupy.
  final double size;

  /// Piece set.
  final PieceAssets pieceAssets;

  @override
  Widget build(BuildContext context) {
    final asset = pieceAssets[piece.kind]!;
    return SizedBox(
      width: size,
      height: size,
      child: asset,
    );
  }
}
