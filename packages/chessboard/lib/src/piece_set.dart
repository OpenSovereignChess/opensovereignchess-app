import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dartsovereignchess/dartsovereignchess.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'models.dart';

const _pieceSetsPath = 'assets/piece_sets';

/// The chess piece set that will be displayed on the board.
enum PieceSet {
  wikimedia('Wikimedia Commons', PieceSet.wikimediaAssets);

  const PieceSet(this.label, this.assets);

  /// The label of this [PieceSet].
  final String label;

  /// The [PieceAssets] for this [PieceSet].
  final PieceAssets assets;

  /// The [PieceAssets] for the 'Wikimedia Commons' piece set.
  static const PieceAssets wikimediaAssets = IMapConst({
    // Ash
    PieceKind.ashBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/aB.svg.vec'),
      semanticsLabel: 'ash bishop',
    ),
    PieceKind.ashKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/aK.svg.vec'),
      semanticsLabel: 'ash king',
    ),
    PieceKind.ashKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/aN.svg.vec'),
      semanticsLabel: 'ash knight',
    ),
    PieceKind.ashPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/aP.svg.vec'),
      semanticsLabel: 'ash pawn',
    ),
    PieceKind.ashQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/aQ.svg.vec'),
      semanticsLabel: 'ash queen',
    ),
    PieceKind.ashRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/aR.svg.vec'),
      semanticsLabel: 'ash rook',
    ),

    // Black
    PieceKind.blackBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/bB.svg.vec'),
      semanticsLabel: 'black bishop',
    ),
    PieceKind.blackKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/bK.svg.vec'),
      semanticsLabel: 'black king',
    ),
    PieceKind.blackKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/bN.svg.vec'),
      semanticsLabel: 'black knight',
    ),
    PieceKind.blackPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/bP.svg.vec'),
      semanticsLabel: 'black pawn',
    ),
    PieceKind.blackQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/bQ.svg.vec'),
      semanticsLabel: 'black queen',
    ),
    PieceKind.blackRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/bR.svg.vec'),
      semanticsLabel: 'black rook',
    ),

    // Cyan
    PieceKind.cyanBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/cB.svg.vec'),
      semanticsLabel: 'cyan bishop',
    ),
    PieceKind.cyanKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/cK.svg.vec'),
      semanticsLabel: 'cyan king',
    ),
    PieceKind.cyanKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/cN.svg.vec'),
      semanticsLabel: 'cyan knight',
    ),
    PieceKind.cyanPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/cP.svg.vec'),
      semanticsLabel: 'cyan pawn',
    ),
    PieceKind.cyanQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/cQ.svg.vec'),
      semanticsLabel: 'cyan queen',
    ),
    PieceKind.cyanRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/cR.svg.vec'),
      semanticsLabel: 'cyan rook',
    ),

    // Green
    PieceKind.greenBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/gB.svg.vec'),
      semanticsLabel: 'green bishop',
    ),
    PieceKind.greenKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/gK.svg.vec'),
      semanticsLabel: 'green king',
    ),
    PieceKind.greenKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/gN.svg.vec'),
      semanticsLabel: 'green knight',
    ),
    PieceKind.greenPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/gP.svg.vec'),
      semanticsLabel: 'green pawn',
    ),
    PieceKind.greenQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/gQ.svg.vec'),
      semanticsLabel: 'green queen',
    ),
    PieceKind.greenRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/gR.svg.vec'),
      semanticsLabel: 'green rook',
    ),

    // Navy
    PieceKind.navyBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/nB.svg.vec'),
      semanticsLabel: 'navy bishop',
    ),
    PieceKind.navyKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/nK.svg.vec'),
      semanticsLabel: 'navy king',
    ),
    PieceKind.navyKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/nN.svg.vec'),
      semanticsLabel: 'navy knight',
    ),
    PieceKind.navyPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/nP.svg.vec'),
      semanticsLabel: 'navy pawn',
    ),
    PieceKind.navyQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/nQ.svg.vec'),
      semanticsLabel: 'navy queen',
    ),
    PieceKind.navyRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/nR.svg.vec'),
      semanticsLabel: 'navy rook',
    ),

    // Orange
    PieceKind.orangeBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/oB.svg.vec'),
      semanticsLabel: 'orange bishop',
    ),
    PieceKind.orangeKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/oK.svg.vec'),
      semanticsLabel: 'orange king',
    ),
    PieceKind.orangeKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/oN.svg.vec'),
      semanticsLabel: 'orange knight',
    ),
    PieceKind.orangePawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/oP.svg.vec'),
      semanticsLabel: 'orange pawn',
    ),
    PieceKind.orangeQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/oQ.svg.vec'),
      semanticsLabel: 'orange queen',
    ),
    PieceKind.orangeRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/oR.svg.vec'),
      semanticsLabel: 'orange rook',
    ),

    // Pink
    PieceKind.pinkBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/pB.svg.vec'),
      semanticsLabel: 'pink bishop',
    ),
    PieceKind.pinkKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/pK.svg.vec'),
      semanticsLabel: 'pink king',
    ),
    PieceKind.pinkKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/pN.svg.vec'),
      semanticsLabel: 'pink knight',
    ),
    PieceKind.pinkPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/pP.svg.vec'),
      semanticsLabel: 'pink pawn',
    ),
    PieceKind.pinkQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/pQ.svg.vec'),
      semanticsLabel: 'pink queen',
    ),
    PieceKind.pinkRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/pR.svg.vec'),
      semanticsLabel: 'pink rook',
    ),

    // Red
    PieceKind.redBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/rB.svg.vec'),
      semanticsLabel: 'red bishop',
    ),
    PieceKind.redKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/rK.svg.vec'),
      semanticsLabel: 'red king',
    ),
    PieceKind.redKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/rN.svg.vec'),
      semanticsLabel: 'red knight',
    ),
    PieceKind.redPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/rP.svg.vec'),
      semanticsLabel: 'red pawn',
    ),
    PieceKind.redQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/rQ.svg.vec'),
      semanticsLabel: 'red queen',
    ),
    PieceKind.redRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/rR.svg.vec'),
      semanticsLabel: 'red rook',
    ),

    // Slate
    PieceKind.slateBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/sB.svg.vec'),
      semanticsLabel: 'slate bishop',
    ),
    PieceKind.slateKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/sK.svg.vec'),
      semanticsLabel: 'slate king',
    ),
    PieceKind.slateKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/sN.svg.vec'),
      semanticsLabel: 'slate knight',
    ),
    PieceKind.slatePawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/sP.svg.vec'),
      semanticsLabel: 'slate pawn',
    ),
    PieceKind.slateQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/sQ.svg.vec'),
      semanticsLabel: 'slate queen',
    ),
    PieceKind.slateRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/sR.svg.vec'),
      semanticsLabel: 'slate rook',
    ),

    // Violet
    PieceKind.violetBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/vB.svg.vec'),
      semanticsLabel: 'violet bishop',
    ),
    PieceKind.violetKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/vK.svg.vec'),
      semanticsLabel: 'violet king',
    ),
    PieceKind.violetKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/vN.svg.vec'),
      semanticsLabel: 'violet knight',
    ),
    PieceKind.violetPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/vP.svg.vec'),
      semanticsLabel: 'violet pawn',
    ),
    PieceKind.violetQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/vQ.svg.vec'),
      semanticsLabel: 'violet queen',
    ),
    PieceKind.violetRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/vR.svg.vec'),
      semanticsLabel: 'violet rook',
    ),

    // White
    PieceKind.whiteBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/wB.svg.vec'),
      semanticsLabel: 'white bishop',
    ),
    PieceKind.whiteKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/wK.svg.vec'),
      semanticsLabel: 'white king',
    ),
    PieceKind.whiteKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/wN.svg.vec'),
      semanticsLabel: 'white knight',
    ),
    PieceKind.whitePawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/wP.svg.vec'),
      semanticsLabel: 'white pawn',
    ),
    PieceKind.whiteQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/wQ.svg.vec'),
      semanticsLabel: 'white queen',
    ),
    PieceKind.whiteRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/wR.svg.vec'),
      semanticsLabel: 'white rook',
    ),

    // Yellow
    PieceKind.yellowBishop: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/yB.svg.vec'),
      semanticsLabel: 'yellow bishop',
    ),
    PieceKind.yellowKing: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/yK.svg.vec'),
      semanticsLabel: 'yellow king',
    ),
    PieceKind.yellowKnight: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/yN.svg.vec'),
      semanticsLabel: 'yellow knight',
    ),
    PieceKind.yellowPawn: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/yP.svg.vec'),
      semanticsLabel: 'yellow pawn',
    ),
    PieceKind.yellowQueen: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/yQ.svg.vec'),
      semanticsLabel: 'yellow queen',
    ),
    PieceKind.yellowRook: SvgPicture(
      AssetBytesLoader('$_pieceSetsPath/wikimedia/yR.svg.vec'),
      semanticsLabel: 'yellow rook',
    ),
  });
}
