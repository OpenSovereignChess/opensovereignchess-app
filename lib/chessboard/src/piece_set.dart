import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
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
    kAshBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/aB.svg.vec'),
      semanticsLabel: 'ash bishop',
    ),
    kAshKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/aK.svg.vec'),
      semanticsLabel: 'ash king',
    ),
    kAshKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/aN.svg.vec'),
      semanticsLabel: 'ash knight',
    ),
    kAshPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/aP.svg.vec'),
      semanticsLabel: 'ash pawn',
    ),
    kAshQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/aQ.svg.vec'),
      semanticsLabel: 'ash queen',
    ),
    kAshRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/aR.svg.vec'),
      semanticsLabel: 'ash rook',
    ),

    // Black
    kBlackBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/bB.svg.vec'),
      semanticsLabel: 'black bishop',
    ),
    kBlackKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/bK.svg.vec'),
      semanticsLabel: 'black king',
    ),
    kBlackKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/bN.svg.vec'),
      semanticsLabel: 'black knight',
    ),
    kBlackPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/bP.svg.vec'),
      semanticsLabel: 'black pawn',
    ),
    kBlackQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/bQ.svg.vec'),
      semanticsLabel: 'black queen',
    ),
    kBlackRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/bR.svg.vec'),
      semanticsLabel: 'black rook',
    ),

    // Cyan
    kCyanBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/cB.svg.vec'),
      semanticsLabel: 'cyan bishop',
    ),
    kCyanKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/cK.svg.vec'),
      semanticsLabel: 'cyan king',
    ),
    kCyanKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/cN.svg.vec'),
      semanticsLabel: 'cyan knight',
    ),
    kCyanPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/cP.svg.vec'),
      semanticsLabel: 'cyan pawn',
    ),
    kCyanQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/cQ.svg.vec'),
      semanticsLabel: 'cyan queen',
    ),
    kCyanRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/cR.svg.vec'),
      semanticsLabel: 'cyan rook',
    ),

    // Green
    kGreenBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/gB.svg.vec'),
      semanticsLabel: 'green bishop',
    ),
    kGreenKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/gK.svg.vec'),
      semanticsLabel: 'green king',
    ),
    kGreenKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/gN.svg.vec'),
      semanticsLabel: 'green knight',
    ),
    kGreenPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/gP.svg.vec'),
      semanticsLabel: 'green pawn',
    ),
    kGreenQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/gQ.svg.vec'),
      semanticsLabel: 'green queen',
    ),
    kGreenRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/gR.svg.vec'),
      semanticsLabel: 'green rook',
    ),

    // Navy
    kNavyBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/nB.svg.vec'),
      semanticsLabel: 'navy bishop',
    ),
    kNavyKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/nK.svg.vec'),
      semanticsLabel: 'navy king',
    ),
    kNavyKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/nN.svg.vec'),
      semanticsLabel: 'navy knight',
    ),
    kNavyPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/nP.svg.vec'),
      semanticsLabel: 'navy pawn',
    ),
    kNavyQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/nQ.svg.vec'),
      semanticsLabel: 'navy queen',
    ),
    kNavyRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/nR.svg.vec'),
      semanticsLabel: 'navy rook',
    ),

    // Orange
    kOrangeBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/oB.svg.vec'),
      semanticsLabel: 'orange bishop',
    ),
    kOrangeKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/oK.svg.vec'),
      semanticsLabel: 'orange king',
    ),
    kOrangeKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/oN.svg.vec'),
      semanticsLabel: 'orange knight',
    ),
    kOrangePawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/oP.svg.vec'),
      semanticsLabel: 'orange pawn',
    ),
    kOrangeQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/oQ.svg.vec'),
      semanticsLabel: 'orange queen',
    ),
    kOrangeRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/oR.svg.vec'),
      semanticsLabel: 'orange rook',
    ),

    // Pink
    kPinkBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/pB.svg.vec'),
      semanticsLabel: 'pink bishop',
    ),
    kPinkKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/pK.svg.vec'),
      semanticsLabel: 'pink king',
    ),
    kPinkKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/pN.svg.vec'),
      semanticsLabel: 'pink knight',
    ),
    kPinkPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/pP.svg.vec'),
      semanticsLabel: 'pink pawn',
    ),
    kPinkQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/pQ.svg.vec'),
      semanticsLabel: 'pink queen',
    ),
    kPinkRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/pR.svg.vec'),
      semanticsLabel: 'pink rook',
    ),

    // Red
    kRedBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/rB.svg.vec'),
      semanticsLabel: 'red bishop',
    ),
    kRedKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/rK.svg.vec'),
      semanticsLabel: 'red king',
    ),
    kRedKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/rN.svg.vec'),
      semanticsLabel: 'red knight',
    ),
    kRedPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/rP.svg.vec'),
      semanticsLabel: 'red pawn',
    ),
    kRedQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/rQ.svg.vec'),
      semanticsLabel: 'red queen',
    ),
    kRedRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/rR.svg.vec'),
      semanticsLabel: 'red rook',
    ),

    // Slate
    kSlateBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/sB.svg.vec'),
      semanticsLabel: 'slate bishop',
    ),
    kSlateKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/sK.svg.vec'),
      semanticsLabel: 'slate king',
    ),
    kSlateKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/sN.svg.vec'),
      semanticsLabel: 'slate knight',
    ),
    kSlatePawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/sP.svg.vec'),
      semanticsLabel: 'slate pawn',
    ),
    kSlateQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/sQ.svg.vec'),
      semanticsLabel: 'slate queen',
    ),
    kSlateRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/sR.svg.vec'),
      semanticsLabel: 'slate rook',
    ),

    // Violet
    kVioletBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/vB.svg.vec'),
      semanticsLabel: 'violet bishop',
    ),
    kVioletKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/vK.svg.vec'),
      semanticsLabel: 'violet king',
    ),
    kVioletKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/vN.svg.vec'),
      semanticsLabel: 'violet knight',
    ),
    kVioletPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/vP.svg.vec'),
      semanticsLabel: 'violet pawn',
    ),
    kVioletQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/vQ.svg.vec'),
      semanticsLabel: 'violet queen',
    ),
    kVioletRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/vR.svg.vec'),
      semanticsLabel: 'violet rook',
    ),

    // White
    kWhiteBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/wB.svg.vec'),
      semanticsLabel: 'white bishop',
    ),
    kWhiteKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/wK.svg.vec'),
      semanticsLabel: 'white king',
    ),
    kWhiteKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/wN.svg.vec'),
      semanticsLabel: 'white knight',
    ),
    kWhitePawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/wP.svg.vec'),
      semanticsLabel: 'white pawn',
    ),
    kWhiteQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/wQ.svg.vec'),
      semanticsLabel: 'white queen',
    ),
    kWhiteRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/wR.svg.vec'),
      semanticsLabel: 'white rook',
    ),

    // Yellow
    kYellowBishopKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/yB.svg.vec'),
      semanticsLabel: 'yellow bishop',
    ),
    kYellowKingKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/yK.svg.vec'),
      semanticsLabel: 'yellow king',
    ),
    kYellowKnightKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/yN.svg.vec'),
      semanticsLabel: 'yellow knight',
    ),
    kYellowPawnKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/yP.svg.vec'),
      semanticsLabel: 'yellow pawn',
    ),
    kYellowQueenKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/yQ.svg.vec'),
      semanticsLabel: 'yellow queen',
    ),
    kYellowRookKind: SvgPicture(
      const AssetBytesLoader('$_pieceSetsPath/wikimedia/yR.svg.vec'),
      semanticsLabel: 'yellow rook',
    ),
  });
}
