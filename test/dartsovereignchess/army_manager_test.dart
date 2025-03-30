import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

void main() {
  group('ArmyManager', () {
    test('basic army ownership', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        controlledBy: IMap({}),
      );

      expect(manager.colorOf(Side.player1), PieceColor.white);
      expect(manager.colorOf(Side.player2), PieceColor.black);
      expect(manager.controlledColorsOf(Side.player1), isEmpty);
      expect(manager.controlledColorsOf(Side.player2), isEmpty);
    });

    test('army control', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        controlledBy: IMap({
          PieceColor.red: PieceColor.white,
          PieceColor.navy: PieceColor.white,
          PieceColor.green: PieceColor.black,
          PieceColor.yellow: PieceColor.black,
        }),
      );

      expect(manager.controlledColorsOf(Side.player1),
          containsAll([PieceColor.red, PieceColor.navy]));
      expect(manager.controlledColorsOf(Side.player2),
          containsAll([PieceColor.green, PieceColor.yellow]));
    });

    test('owned armies', () {
      ArmyManager manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        controlledBy: IMap({
          PieceColor.red: PieceColor.white,
          PieceColor.green: PieceColor.black,
        }),
      );

      manager = manager.setOwnedColor(Side.player1, PieceColor.green);
      expect(manager.colorOf(Side.player1), PieceColor.white);
      manager = manager.setOwnedColor(Side.player1, PieceColor.red);
      expect(manager.colorOf(Side.player1), PieceColor.red);
    });
  });
}
