import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Use same box shadows as material widgets with elevation 1.
final List<BoxShadow> boardShadows = defaultTargetPlatform == TargetPlatform.iOS
    ? <BoxShadow>[]
    : kElevationToShadow[1]!;

const kTabletBoardTableSidePadding = 16.0;
const kBottomBarHeight = 56.0;

/// The threshold to detect screens with a small remaining height left board.
const kSmallRemainingHeightLeftBoardThreshold = 160;
