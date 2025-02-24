import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/army_manager.dart';
//import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

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
    });

    test('army control', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({PieceColor.red, PieceColor.blue}),
        p2Controlled: ISet({PieceColor.green, PieceColor.yellow}),
      );

      expect(manager.p1Controlled, containsAll([PieceColor.red, PieceColor.blue]));
      expect(manager.p2Controlled, containsAll([PieceColor.green, PieceColor.yellow]));
    });

    test('color mapping', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({PieceColor.red}),
        p2Controlled: ISet({PieceColor.green}),
      );

      expect(manager.colorOf(Side.player1), PieceColor.white);
      expect(manager.colorOf(Side.player2), PieceColor.black);
      expect(manager.sideOf(PieceColor.white), Side.player1);
      expect(manager.sideOf(PieceColor.black), Side.player2);
      expect(manager.sideOf(PieceColor.red), Side.player1);
      expect(manager.sideOf(PieceColor.green), Side.player2);
    });

    test('controlled armies', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({PieceColor.red, PieceColor.navy}),
        p2Controlled: ISet({PieceColor.green, PieceColor.cyan}),
      );

      expect(manager.isControlledBy(Side.player1, PieceColor.red), isTrue);
      expect(manager.isControlledBy(Side.player1, PieceColor.navy), isTrue);
      expect(manager.isControlledBy(Side.player2, PieceColor.green), isTrue);
      expect(manager.isControlledBy(Side.player2, PieceColor.cyan), isTrue);
      expect(manager.isControlledBy(Side.player1, PieceColor.green), isFalse);
      expect(manager.isControlledBy(Side.player2, PieceColor.red), isFalse);
    });

    test('owned armies', () {
      final manager = ArmyManager(
        p1Owned: PieceColor.white,
        p2Owned: PieceColor.black,
        p1Controlled: ISet({PieceColor.red}),
        p2Controlled: ISet({PieceColor.green}),
      );

      expect(manager.isOwnedBy(Side.player1, PieceColor.white), isTrue);
      expect(manager.isOwnedBy(Side.player2, PieceColor.black), isTrue);
      expect(manager.isOwnedBy(Side.player1, PieceColor.black), isFalse);
      expect(manager.isOwnedBy(Side.player2, PieceColor.white), isFalse);
    });
  });
}
