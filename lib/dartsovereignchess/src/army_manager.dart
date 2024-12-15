import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './models.dart';

@immutable
class ArmyManager {
  const ArmyManager({
    required this.p1Owned,
    required this.p2Owned,
    required this.p1Controlled,
    required this.p2Controlled,
  });

  /// The color army player 1 owns.
  final PieceColor p1Owned;

  /// The color armies that player 1 controls.
  final ISet<PieceColor> p1Controlled;

  /// The color army player 2 owns.
  final PieceColor p2Owned;

  /// The color armies that player 2 controls.
  final ISet<PieceColor> p2Controlled;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ArmyManager &&
            runtimeType == other.runtimeType &&
            p1Owned == other.p1Owned &&
            p2Owned == other.p2Owned &&
            p1Controlled == other.p1Controlled &&
            p2Controlled == other.p2Controlled;
  }

  @override
  int get hashCode => Object.hash(
        p1Owned,
        p2Owned,
        p1Controlled,
        p2Controlled,
      );

  ArmyManager copyWith({
    PieceColor? p1Owned,
    PieceColor? p2Owned,
    ISet<PieceColor>? p1Controlled,
    ISet<PieceColor>? p2Controlled,
  }) {
    return ArmyManager(
      p1Owned: p1Owned ?? this.p1Owned,
      p2Owned: p2Owned ?? this.p2Owned,
      p1Controlled: p1Controlled ?? this.p1Controlled,
      p2Controlled: p2Controlled ?? this.p2Controlled,
    );
  }

  /// Returns the owned [PieceColor] for the given [Side].
  PieceColor ownedColor(Side turn) => switch (turn) {
        Side.player1 => p1Owned,
        Side.player2 => p2Owned,
      };

  /// Returns true if the given [Side] controls the [PieceColor].
  ///
  /// Returns false in the case where the given [Side] owns instead of controls
  /// the [PieceColor].
  bool controls(Side turn, PieceColor color) => switch (turn) {
        Side.player1 => p1Controlled.contains(color),
        Side.player2 => p2Controlled.contains(color),
      };

  ISet<PieceColor> colorsOf(Side turn) {
    return switch (turn) {
      Side.player1 => [
          p1Owned,
          ...p1Controlled,
        ].toISet(),
      Side.player2 => [
          p2Owned,
          ...p2Controlled,
        ].toISet(),
    };
  }

  PieceColor colorOf(Side turn) {
    return switch (turn) {
      Side.player1 => p1Owned,
      Side.player2 => p2Owned,
    };
  }

  ArmyManager removeControlledArmy(Side turn, PieceColor color) {
    switch (turn) {
      case Side.player1:
        return copyWith(
          p1Controlled: p1Controlled.remove(color),
        );
      case Side.player2:
        return copyWith(
          p2Controlled: p2Controlled.remove(color),
        );
    }
  }

  ArmyManager addControlledArmy(Side turn, PieceColor color) {
    switch (turn) {
      case Side.player1:
        return copyWith(
          p1Controlled: p1Controlled.add(color),
        );
      case Side.player2:
        return copyWith(
          p2Controlled: p2Controlled.add(color),
        );
    }
  }

  ArmyManager setOwnedColor(Side turn, PieceColor color) {
    return switch (turn) {
      Side.player1 => copyWith(
          p1Owned: color,
          p1Controlled: removeControlledArmy(Side.player1, color).p1Controlled,
        ),
      Side.player2 => copyWith(
          p2Owned: color,
          p2Controlled: removeControlledArmy(Side.player2, color).p2Controlled,
        ),
    };
  }
}
