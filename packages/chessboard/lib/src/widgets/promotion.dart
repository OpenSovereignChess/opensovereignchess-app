import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';
import '../models.dart';
import './geometry.dart';
import './piece.dart';

/// A widget that allows the user to select a promotion piece.
///
/// This widget shoudl be displayed when a pawn reaches the promotion box and must
/// be promoted. The user can select a piece to promote to by tapping on one of
/// the four pieces displayed.
/// Promotion can be canceled by tapping outside the promotion widget.
class PromotionSelector extends StatelessWidget with ChessboardGeometry {
  const PromotionSelector({
    super.key,
    required this.move,
    required this.color,
    required this.size,
    required this.orientation,
    required this.onSelect,
    required this.onCancel,
    required this.pieceAssets,
    this.roles,
  });

  /// The move that is being promoted.
  final NormalMove move;

  /// The color of the pieces to display.
  final PieceColor color;

  /// The piece assets to use.
  final PieceAssets pieceAssets;

  @override
  final double size;

  @override
  final Side orientation;

  /// Callback when a piece is selected.
  final void Function(Role) onSelect;

  /// Callback when the promotion is canceled.
  final void Function() onCancel;

  /// The roles that we can promote to.
  final ISet<Role>? roles;

  /// The square the pawn is moving to.
  Square get square => move.to;

  static const ISet<Role> defaultPromotionRoles =
      ISetConst({Role.queen, Role.knight, Role.rook, Role.bishop, Role.king});

  @override
  Widget build(BuildContext context) {
    final anchorSquare = square;
    final offset = squareOffset(anchorSquare);
    final effectiveRoles = roles ?? defaultPromotionRoles;
    final pieces = [
      Piece(
        color: color,
        role: Role.queen,
        promoted: true,
      ),
      Piece(
        color: color,
        role: Role.knight,
        promoted: true,
      ),
      Piece(
        color: color,
        role: Role.rook,
        promoted: true,
      ),
      Piece(
        color: color,
        role: Role.bishop,
        promoted: true,
      ),
      Piece(
        color: color,
        role: Role.king,
        promoted: true,
      ),
    ]
        .where((piece) => effectiveRoles.contains(piece.role))
        .toList(growable: false);

    return GestureDetector(
      onTap: () => onCancel(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xB3161512),
        child: Stack(
          children: [
            Positioned(
              width: squareSize,
              height: squareSize * 5,
              left: offset.dx,
              top: offset.dy,
              child: Column(
                children: pieces.map((Piece piece) {
                  return GestureDetector(
                    onTap: () => onSelect(piece.role),
                    child: Stack(
                      children: [
                        Container(
                          width: squareSize,
                          height: squareSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0XFFB0B0B0),
                              ),
                              BoxShadow(
                                color: Color(0xFF808080),
                                blurRadius: 25.0,
                                spreadRadius: -3.0,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 5.0,
                          top: 5.0,
                          child: PieceWidget(
                            piece: piece,
                            size: squareSize - 10.0,
                            pieceAssets: pieceAssets,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
