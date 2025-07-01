import 'package:dartsovereignchess/dartsovereignchess.dart'
    show PieceColor, File, Rank, Side, Square;
import 'package:flutter/widgets.dart';

/// Base widget for the background of the chessboard.
///
/// See [SolidColorChessboardBackground] for concrete implementations.
abstract class ChessboardBackground extends StatelessWidget {
  const ChessboardBackground({
    super.key,
    this.coordinates = false,
    this.orientation = Side.player1,
    required this.grid,
    required this.promotionBox,
    required this.pawnGuideline,
    required this.lightSquare,
    required this.darkSquare,
    required this.ashSquare,
    required this.blackSquare,
    required this.cyanSquare,
    required this.greenSquare,
    required this.navySquare,
    required this.orangeSquare,
    required this.pinkSquare,
    required this.redSquare,
    required this.slateSquare,
    required this.violetSquare,
    required this.whiteSquare,
    required this.yellowSquare,
  });

  final bool coordinates;
  final Side orientation;
  final Color grid;
  final Color promotionBox;
  final Color pawnGuideline;
  final Color lightSquare;
  final Color darkSquare;
  final Color ashSquare;
  final Color blackSquare;
  final Color cyanSquare;
  final Color greenSquare;
  final Color navySquare;
  final Color orangeSquare;
  final Color pinkSquare;
  final Color redSquare;
  final Color slateSquare;
  final Color violetSquare;
  final Color whiteSquare;
  final Color yellowSquare;
}

/// A chessboard background with solid color squares.
class SolidColorChessboardBackground extends ChessboardBackground {
  const SolidColorChessboardBackground({
    super.key,
    super.coordinates,
    super.orientation,
    required super.grid,
    required super.promotionBox,
    required super.pawnGuideline,
    required super.lightSquare,
    required super.darkSquare,
    required super.ashSquare,
    required super.blackSquare,
    required super.cyanSquare,
    required super.greenSquare,
    required super.navySquare,
    required super.orangeSquare,
    required super.pinkSquare,
    required super.redSquare,
    required super.slateSquare,
    required super.violetSquare,
    required super.whiteSquare,
    required super.yellowSquare,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _SolidColorChessboardPainter(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        ashSquare: ashSquare,
        blackSquare: blackSquare,
        cyanSquare: cyanSquare,
        greenSquare: greenSquare,
        navySquare: navySquare,
        orangeSquare: orangeSquare,
        pinkSquare: pinkSquare,
        redSquare: redSquare,
        slateSquare: slateSquare,
        violetSquare: violetSquare,
        whiteSquare: whiteSquare,
        yellowSquare: yellowSquare,
        grid: grid,
        promotionBox: promotionBox,
        pawnGuideline: pawnGuideline,
        coordinates: coordinates,
        orientation: orientation,
      ),
    );
  }
}

class _SolidColorChessboardPainter extends CustomPainter {
  _SolidColorChessboardPainter({
    required this.lightSquare,
    required this.darkSquare,
    required this.ashSquare,
    required this.blackSquare,
    required this.cyanSquare,
    required this.greenSquare,
    required this.navySquare,
    required this.orangeSquare,
    required this.pinkSquare,
    required this.redSquare,
    required this.slateSquare,
    required this.violetSquare,
    required this.whiteSquare,
    required this.yellowSquare,
    required this.grid,
    required this.promotionBox,
    required this.pawnGuideline,
    required this.coordinates,
    required this.orientation,
  });

  final Color lightSquare;
  final Color darkSquare;
  final Color ashSquare;
  final Color blackSquare;
  final Color cyanSquare;
  final Color greenSquare;
  final Color navySquare;
  final Color orangeSquare;
  final Color pinkSquare;
  final Color redSquare;
  final Color slateSquare;
  final Color violetSquare;
  final Color whiteSquare;
  final Color yellowSquare;
  final Color grid;
  final Color promotionBox;
  final Color pawnGuideline;
  final bool coordinates;
  final Side orientation;

  @override
  void paint(Canvas canvas, Size size) {
    final rankLen = Rank.values.length;
    final maxRank = Rank.values.last;
    final squareSize = size.shortestSide / rankLen;
    for (var rank = 0; rank < rankLen; rank++) {
      for (var file = 0; file < rankLen; file++) {
        final square = Rect.fromLTWH(
          file * squareSize,
          rank * squareSize,
          squareSize,
          squareSize,
        );
        final paint = Paint()
          ..color =
              getSquareColor(File.values[file], Rank.values[maxRank - rank]);
        canvas.drawRect(square, paint);

        // Draw gridlines
        final borderPaint = Paint()..color = grid;
        borderPaint.style = PaintingStyle.stroke;
        borderPaint.strokeWidth = 0.25;
        canvas.drawRect(square, borderPaint);

        // Draw coordinates
        if (coordinates && (file == maxRank || rank == maxRank)) {
          final coordStyle = TextStyle(
            inherit: false,
            fontWeight: FontWeight.bold,
            fontSize: 10.0,
            color: Color(0x33000000),
            fontFamily: 'Roboto',
            height: 1.0,
          );
          if (file == maxRank) {
            final coord = TextPainter(
              text: TextSpan(
                text: orientation == Side.player1
                    ? '${rankLen - rank}'
                    : '${rank + 1}',
                style: coordStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            coord.layout();
            const edgeOffset = 2.0;
            final offset = Offset(
              file * squareSize + (squareSize - coord.width) - edgeOffset,
              rank * squareSize + edgeOffset,
            );
            coord.paint(canvas, offset);
          }
          if (rank == maxRank) {
            final coord = TextPainter(
              text: TextSpan(
                text: orientation == Side.player1
                    ? String.fromCharCode(97 + file)
                    : String.fromCharCode(97 + 7 - file),
                style: coordStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            coord.layout();
            const edgeOffset = 2.0;
            final offset = Offset(
              file * squareSize + edgeOffset,
              rank * squareSize + (squareSize - coord.height) - edgeOffset,
            );
            coord.paint(canvas, offset);
          }
        }
      }
    }

    // Draw promotion box
    final boxPaint = Paint()..color = promotionBox;
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2.0;
    canvas.drawRect(
      Rect.fromLTWH(
        File.g * squareSize,
        (maxRank - Rank.tenth) * squareSize,
        squareSize * 4,
        squareSize * 4,
      ),
      boxPaint,
    );

    // Draw pawn guidelines
    final linePaint = Paint()..color = pawnGuideline;
    linePaint.strokeWidth = 2.0;
    canvas.drawLine(
      Offset(File.a as double, (maxRank - Rank.eighth) as double) * squareSize,
      Offset(File.g as double, (maxRank - Rank.eighth) as double) * squareSize,
      linePaint,
    );
    canvas.drawLine(
      Offset(File.k as double, (maxRank - Rank.eighth) as double) * squareSize,
      Offset(File.p + 1.0, (maxRank - Rank.eighth) as double) * squareSize,
      linePaint,
    );
    canvas.drawLine(
      Offset(File.i as double, maxRank + 1.0) * squareSize,
      Offset(File.i as double, (maxRank - Rank.sixth) as double) * squareSize,
      linePaint,
    );
    canvas.drawLine(
      Offset(File.i as double, (maxRank - Rank.tenth) as double) * squareSize,
      Offset(File.i as double, (maxRank - Rank.sixteenth) as double) *
          squareSize,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  Color getSquareColor(File file, Rank rank) {
    final sq = Square.fromCoords(file, rank);
    return switch (sq.color) {
      PieceColor.ash => ashSquare,
      PieceColor.black => blackSquare,
      PieceColor.cyan => cyanSquare,
      PieceColor.green => greenSquare,
      PieceColor.navy => navySquare,
      PieceColor.orange => orangeSquare,
      PieceColor.pink => pinkSquare,
      PieceColor.red => redSquare,
      PieceColor.slate => slateSquare,
      PieceColor.violet => violetSquare,
      PieceColor.white => whiteSquare,
      PieceColor.yellow => yellowSquare,
      _ => (rank + file).isEven ? darkSquare : lightSquare,
    };
  }
}
