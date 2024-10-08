import 'package:flutter/widgets.dart';

/// A chessboard background with solid color squares.
class ChessboardBackground extends StatelessWidget {
  const ChessboardBackground({
    super.key,
    this.coordinates = false,
    this.sideLengthInSquares = 16,
    required this.lightSquare,
    required this.darkSquare,
    required this.grid,
  });

  final bool coordinates;
  final int sideLengthInSquares;
  final Color lightSquare;
  final Color darkSquare;
  final Color grid;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox.expand(
        child: Column(
          children: List.generate(
            sideLengthInSquares,
            (rank) => Expanded(
              child: Row(
                children: List.generate(
                  sideLengthInSquares,
                  (file) => Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.25,
                          color: grid,
                        ),
                        color: (rank + file).isEven ? lightSquare : darkSquare,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
