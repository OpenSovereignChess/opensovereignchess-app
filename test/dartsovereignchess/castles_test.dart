import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';
import 'package:opensovereignchess_app/dartsovereignchess/src/castles.dart';
//import 'package:opensovereignchess_app/dartsovereignchess/src/debug.dart';

void main() {
  group('Castles', () {
    test('fromSetup', () {
      final castles = Castles.fromSetup(Setup.standard);
      expect(castles.castlingRights, SquareSet.castlingRooks);
      //print(humanReadableSquareSet(castles.castlingRights));
      //print(humanReadableSquareSet(SquareSet.castlingRooks));
      expect(castles, Castles.standard);

      expect(castles.rookOf(Side.player1, CastlingSide.queen), Square.e1);
      expect(castles.rookOf(Side.player1, CastlingSide.king), Square.l1);
      expect(castles.rookOf(Side.player2, CastlingSide.queen), Square.e16);
      expect(castles.rookOf(Side.player2, CastlingSide.king), Square.l16);

      expect(castles.pathOf(Side.player1, CastlingSide.queen).squares,
          equals([Square.f1, Square.g1, Square.h1]));
      expect(castles.pathOf(Side.player1, CastlingSide.king).squares,
          equals([Square.j1, Square.k1]));
      expect(castles.pathOf(Side.player2, CastlingSide.queen).squares,
          equals([Square.f16, Square.g16, Square.h16]));
      expect(castles.pathOf(Side.player2, CastlingSide.king).squares,
          equals([Square.j16, Square.k16]));
    });

    test('discard rook', () {
      expect(Castles.standard.discardRookAt(Square.a4), Castles.standard);
      expect(
          Castles.standard
              .discardRookAt(Square.l1)
              .rooksPositions[Side.player1],
          IMap(const {
            CastlingSide.queen: Square.e1,
            CastlingSide.king: Square.n1
          }));
    });

    test('discard side', () {
      expect(
          Castles.standard.discardSide(Side.player1).rooksPositions,
          equals(BySide({
            Side.player1: ByCastlingSide(
              const {CastlingSide.queen: null, CastlingSide.king: null},
            ),
            Side.player2: ByCastlingSide(
              const {
                CastlingSide.queen: Square.e16,
                CastlingSide.king: Square.l16,
              },
            )
          })));

      expect(
          Castles.standard.discardSide(Side.player2).rooksPositions,
          equals(BySide({
            Side.player1: ByCastlingSide(const {
              CastlingSide.queen: Square.e1,
              CastlingSide.king: Square.l1,
            }),
            Side.player2: ByCastlingSide(
                const {CastlingSide.queen: null, CastlingSide.king: null})
          })));
    });
  });
}
