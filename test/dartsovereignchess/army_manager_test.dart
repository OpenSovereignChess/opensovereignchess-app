import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/army_manager.dart';

void main() {
  group('ArmyManager', () {
    test('basic army ownership', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({}),
        p2Controlled: ISet({}),
      );

      expect(manager.p1Owned, PieceColor.white);
      expect(manager.p2Owned, PieceColor.black);
      expect(manager.p1Controlled, isEmpty);
      expect(manager.p2Controlled, isEmpty);
      expect(manager.colorOf(Side.player1), PieceColor.white);
      expect(manager.colorOf(Side.player2), PieceColor.black);
    });

    test('army control', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({PieceColor.red, PieceColor.navy}),
        p2Controlled: ISet({PieceColor.green, PieceColor.yellow}),
      );

      expect(
          manager.p1Controlled, containsAll([PieceColor.red, PieceColor.navy]));
      expect(manager.p2Controlled,
          containsAll([PieceColor.green, PieceColor.yellow]));
    });

    test('owned armies', () {
      ArmyManager manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({PieceColor.red}),
        p2Controlled: ISet({PieceColor.green}),
      );

      manager = manager.setOwnedColor(Side.player1, PieceColor.green);
      expect(manager.colorOf(Side.player1), PieceColor.white);
      manager = manager.setOwnedColor(Side.player1, PieceColor.red);
      expect(manager.colorOf(Side.player1), PieceColor.red);
    });
  });
}
