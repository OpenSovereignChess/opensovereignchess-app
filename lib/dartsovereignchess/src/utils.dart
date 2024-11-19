import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import './models.dart';
import './position.dart';

/// Returns all the legal moves of the [Position] in a convenient format.
IMap<Square, ISet<Square>> makeLegalMoves(Position pos) {
  final Map<Square, ISet<Square>> result = {};
  for (final entry in pos.legalMoves.entries) {
    final dests = entry.value.squares;
    if (dests.isNotEmpty) {
      final from = entry.key;
      final destSet = dests.toSet();
      result[from] = ISet(destSet);
    }
  }
  return IMap(result);
}
