import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

import 'models.dart';

const _pieceSetsPath = 'assets/piece_sets';

/// The chess piece set that will be displayed on the board.
enum PieceSet {
  cburnett('Colin M.L. Burnett', PieceSet.cburnettAssets);

  const PieceSet(this.label, this.assets);

  /// The label of this [PieceSet].
  final String label;

  /// The [PieceAssets] for this [PieceSet].
  final PieceAssets assets;

  /// The [PieceAssets] for the 'Colin M.L. Burnett' piece set.
  static const PieceAssets cburnettAssets = IMapConst({
    kBlackRookKind: AssetImage('$_pieceSetsPath/cburnett/bR.png'),
  });
}
