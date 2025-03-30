import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './models.dart';

@immutable
class ArmyManager {
  const ArmyManager({
    required this.p1Owned,
    required this.p2Owned,
    required this.controlledBy,
  });

  /// The color army player 1 owns.
  final PieceColor p1Owned;

  /// The color army player 2 owns.
  final PieceColor p2Owned;

  /// Who controls a color army.
  final IMap<PieceColor, PieceColor> controlledBy;

  /// Army Manager for an empty board.
  static const empty = ArmyManager(
    p1Owned: PieceColor.white,
    p2Owned: PieceColor.black,
    controlledBy: IMap.empty(),
  );

  /// Army Manager for a standard board.
  static const standard = ArmyManager(
    p1Owned: PieceColor.white,
    p2Owned: PieceColor.black,
    controlledBy: IMap.empty(),
  );

  @override
  String toString() {
    return 'ArmyManager(p1Owned: $p1Owned, p2Owned: $p2Owned, controlledBy: $controlledBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ArmyManager &&
            runtimeType == other.runtimeType &&
            p1Owned == other.p1Owned &&
            p2Owned == other.p2Owned &&
            controlledBy == other.controlledBy;
  }

  @override
  int get hashCode => Object.hash(
        p1Owned,
        p2Owned,
        controlledBy,
      );

  ArmyManager copyWith({
    PieceColor? p1Owned,
    PieceColor? p2Owned,
    IMap<PieceColor, PieceColor>? controlledBy,
  }) {
    return ArmyManager(
      p1Owned: p1Owned ?? this.p1Owned,
      p2Owned: p2Owned ?? this.p2Owned,
      controlledBy: controlledBy ?? this.controlledBy,
    );
  }

  /// Return the colors controlled by the given [PieceColor].
  ISet<PieceColor> _controlledColorsOf(PieceColor color) {
    // Find direct colors controlled by the given color
    ISet<PieceColor> directlyControlled = controlledBy.entries
        .where((entry) => entry.value == color)
        .map((entry) => entry.key)
        .toISet();

    // For each directly controlled color, add colors they control
    ISet<PieceColor> result = directlyControlled;
    for (final controlledColor in directlyControlled) {
      if (controlledColor != color) {
        // Avoid infinite recursion
        result = result.union(_controlledColorsOf(controlledColor));
      }
    }
    return result;
  }

  /// Returns true if the given [Side] controls the [PieceColor].
  ///
  /// Returns false in the case where the given [Side] owns instead of controls
  /// the [PieceColor].
  bool controls(Side turn, PieceColor color) =>
      controlledColorsOf(turn).contains(color);

  /// Returns both owned and controlled [PieceColor]s for a given [Side].
  ISet<PieceColor> colorsOf(Side turn) {
    return [
      colorOf(turn),
      ...controlledColorsOf(turn),
    ].toISet();
  }

  /// Returns the owned [PieceColor] for the given [Side].
  PieceColor colorOf(Side turn) => switch (turn) {
        Side.player1 => p1Owned,
        Side.player2 => p2Owned,
      };

  /// Returns the controlled [PieceColor]s for the given [Side].
  ISet<PieceColor> controlledColorsOf(Side turn) {
    final ownedColor = turn == Side.player1 ? p1Owned : p2Owned;
    return _controlledColorsOf(ownedColor);
  }

  ArmyManager removeControlledArmy(PieceColor color) {
    return copyWith(
      controlledBy: controlledBy.remove(color),
    );
  }

  ArmyManager addControlledArmy(PieceColor controllerColor, PieceColor color) {
    // Cannot control an owned army
    if (color == p1Owned || color == p2Owned) {
      return copyWith();
    }

    return copyWith(
      controlledBy: controlledBy.update(color, (v) => controllerColor,
          ifAbsent: () => controllerColor),
    );
  }

  ArmyManager setOwnedColor(Side turn, PieceColor color) {
    // Cannot change to a color you do not control
    if (!controlledColorsOf(turn).contains(color)) {
      return copyWith();
    }
    return copyWith(
      p1Owned: turn == Side.player1 ? color : p1Owned,
      p2Owned: turn == Side.player2 ? color : p2Owned,
      controlledBy: controlledBy.remove(color),
    );
  }
}
