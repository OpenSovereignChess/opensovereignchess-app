import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

/// Describes a set of piece assets.
///
/// The [PieceAssets] must be complete with all the pieces for both sides.
typedef PieceAssets = IMap<PieceKind, AssetImage>;

/// Representation of the piece positions on a board.
typedef Pieces = Map<Square, Piece>;
