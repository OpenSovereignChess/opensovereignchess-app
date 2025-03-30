import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import './army_manager.dart';
import './attacks.dart';
import './models.dart';
import './square_set.dart';

/// A board represented by several square sets for each piece.
@immutable
class Board {
  const Board({
    required this.occupied,
    required this.white,
    required this.ash,
    required this.slate,
    required this.black,
    required this.pink,
    required this.red,
    required this.orange,
    required this.yellow,
    required this.green,
    required this.cyan,
    required this.navy,
    required this.violet,
    required this.pawns,
    required this.knights,
    required this.bishops,
    required this.rooks,
    required this.queens,
    required this.kings,
    required this.armyManager,
  });

  /// All occupied squares.
  final SquareSet occupied;

  /// All squares occupied by white pieces.
  final SquareSet white;

  /// All squares occupied by ash pieces.
  final SquareSet ash;

  /// All squares occupied by slate pieces.
  final SquareSet slate;

  /// All squares occupied by black pieces.
  final SquareSet black;

  /// All squares occupied by pink pieces.
  final SquareSet pink;

  /// All squares occupied by red pieces.
  final SquareSet red;

  /// All squares occupied by orange pieces.
  final SquareSet orange;

  /// All squares occupied by yellow pieces.
  final SquareSet yellow;

  /// All squares occupied by green pieces.
  final SquareSet green;

  /// All squares occupied by cyan pieces.
  final SquareSet cyan;

  /// All squares occupied by navy pieces.
  final SquareSet navy;

  /// All squares occupied by violet pieces.
  final SquareSet violet;

  /// All squares occupied by pawns.
  final SquareSet pawns;

  /// All squares occupied by knights.
  final SquareSet knights;

  /// All squares occupied by bishops.
  final SquareSet bishops;

  /// All squares occupied by rooks.
  final SquareSet rooks;

  /// All squares occupied by queens.
  final SquareSet queens;

  /// All squares occupied by kings.
  final SquareSet kings;

  /// Manager for each player's owned and controlled armies.
  final ArmyManager armyManager;

  /// Standard chess starting position.
  static const standard = Board(
    occupied: SquareSet(0xFFFFFFFF, 0xC003C003, 0xC003C003, 0xC003C003,
        0xC003C003, 0xC003C003, 0xC003C003, 0xFFFFFFFF),
    white: SquareSet(0, 0, 0, 0, 0, 0, 0, 0xFF00FF0),
    ash: SquareSet(0x30003, 0, 0, 0, 0, 0, 0, 0xC000C000),
    slate: SquareSet(0xC000C000, 0, 0, 0, 0, 0, 0, 0x30003),
    black: SquareSet(0xFF00FF0, 0, 0, 0, 0, 0, 0, 0),
    pink: SquareSet(0, 0, 0, 0xC000C000, 0, 0, 0, 0xC000C),
    red: SquareSet(0, 0, 0xC000C000, 0, 0, 0, 0x30003, 0),
    orange: SquareSet(0, 0xC000C000, 0, 0, 0, 0x30003, 0, 0),
    yellow: SquareSet(0x30003000, 0, 0, 0, 0x30003, 0, 0, 0),
    green: SquareSet(0, 0, 0, 0x30003, 0, 0, 0, 0x30003000),
    cyan: SquareSet(0, 0, 0x3003, 0, 0, 0, 0xC000C000, 0),
    navy: SquareSet(0, 0xC000C000, 0, 0, 0, 0x3003, 0, 0),
    violet: SquareSet(0xC000C, 0, 0, 0, 0xC000C000, 0, 0, 0),
    pawns: SquareSet(0x3FFC, 0x40024002, 0x40024002, 0x40024002, 0x40024002,
        0x40024002, 0x40024002, 0x3FFC0000),
    knights: SquareSet(0x14284002, 0, 0x8001, 0, 0, 0x80010000, 0, 0x40021428),
    bishops: SquareSet(
        0x42420000, 0x80010000, 0, 0x80010000, 0x8001, 0, 0x8001, 0x4242),
    rooks: SquareSet(0x28148001, 0, 0x80010000, 0, 0, 0x8001, 0, 0x80012814),
    queens: SquareSet(
        0x80810000, 0x8001, 0, 0x8001, 0x80010000, 0, 0x80010000, 0x8081),
    kings: SquareSet(0x1000000, 0, 0, 0, 0, 0, 0, 0x100),
    armyManager: ArmyManager.standard,
  );

  /// Empty board.
  static const empty = Board(
    occupied: SquareSet.empty,
    white: SquareSet.empty,
    ash: SquareSet.empty,
    slate: SquareSet.empty,
    black: SquareSet.empty,
    pink: SquareSet.empty,
    red: SquareSet.empty,
    orange: SquareSet.empty,
    yellow: SquareSet.empty,
    green: SquareSet.empty,
    cyan: SquareSet.empty,
    navy: SquareSet.empty,
    violet: SquareSet.empty,
    pawns: SquareSet.empty,
    knights: SquareSet.empty,
    bishops: SquareSet.empty,
    rooks: SquareSet.empty,
    queens: SquareSet.empty,
    kings: SquareSet.empty,
    armyManager: ArmyManager.empty,
  );

  /// Parse the board part of a FEN string and returns a Board.
  ///
  /// Throws a [FenException] if the provided FEN string is not valid.
  factory Board.parseFen(String boardFen) {
    Board board = Board.empty;
    int rank = Rank.values.last;
    int file = File.values.first;
    String pieceToken = '';
    String skippedToken = '';

    for (final c in boardFen.characters) {
      switch (c) {
        case '/':
          --rank;
          if (rank < 0) {
            return board;
          }
          file = File.values.first as int;
          skippedToken = '';
        default:
          final code = c.codeUnitAt(0);
          // Check if code is a digit, and not a letter
          if (code < 58) {
            skippedToken += c;
          } else {
            pieceToken += c;

            // Process skipped spaces if any
            if (skippedToken.isNotEmpty) {
              final skippedSpaces = int.parse(skippedToken);
              file += skippedSpaces;
              skippedToken = '';
            }
          }

          if (file > File.values.last || rank < Rank.values.first) {
            throw const FenException(IllegalFenCause.board);
          }

          // Piece token will always be two chars - a color and a role.
          if (pieceToken.length == 2) {
            final colorLetter = pieceToken[0];
            final roleLetter = pieceToken[1];
            final square = Square.fromCoords(File(file), Rank(rank));
            final piece = Piece(
              color: PieceColor.fromChar(colorLetter)!,
              role: Role.fromChar(roleLetter)!,
            );
            board = board.setPieceAt(square, piece);
            ++file;
            pieceToken = '';
          }
      }
      //print('rank=$rank file=$file');
    }
    if (skippedToken.isNotEmpty) {
      file += int.parse(skippedToken);
      //print('finally rank=$rank file=$file');
    }
    if (rank != Rank.values.first || file != File.values.last + 1) {
      //print('last check: rank=$rank file=$file');
      throw const FenException(IllegalFenCause.board);
    }
    return board;
  }

  /// The square set of all rooks and queens.
  SquareSet get rooksAndQueens => rooks | queens;

  /// The square set of all bishops and queens.
  SquareSet get bishopsAndQueens => bishops | queens;

  /// Board part of the FEN.
  String get fen {
    final buffer = StringBuffer();
    int empty = 0;
    int lastFile = File.values.length - 1;
    for (int rank = Rank.values.length - 1; rank >= 0; rank--) {
      for (int file = 0; file < File.values.length; file++) {
        final square = Square.fromCoords(File(file), Rank(rank));
        final piece = pieceAt(square);
        if (piece == null) {
          empty++;
        } else {
          if (empty > 0) {
            buffer.write(empty.toString());
            empty = 0;
          }
          buffer.write(piece.fenStr);
        }

        if (file == lastFile) {
          if (empty > 0) {
            buffer.write(empty.toString());
            empty = 0;
          }
          if (rank != 0) {
            buffer.write('/');
          }
        }
      }
    }
    return buffer.toString();
  }

  IMap<PieceColor, SquareSet> _colorMap() => (IMap({
        PieceColor.white: white,
        PieceColor.ash: ash,
        PieceColor.slate: slate,
        PieceColor.black: black,
        PieceColor.pink: pink,
        PieceColor.red: red,
        PieceColor.orange: orange,
        PieceColor.yellow: yellow,
        PieceColor.green: green,
        PieceColor.cyan: cyan,
        PieceColor.navy: navy,
        PieceColor.violet: violet,
      }));

  /// Gets all squares occupied by [Side].
  ///
  /// This includes all owned and controlled pieces of [Side].
  SquareSet bySide(Side side) => byColors(armyManager.colorsOf(side));

  /// Gets all squares occupied by pieces of [PieceColor].
  SquareSet byColor(PieceColor color) {
    return switch (color) {
      PieceColor.white => white,
      PieceColor.ash => ash,
      PieceColor.slate => slate,
      PieceColor.black => black,
      PieceColor.pink => pink,
      PieceColor.red => red,
      PieceColor.orange => orange,
      PieceColor.yellow => yellow,
      PieceColor.green => green,
      PieceColor.cyan => cyan,
      PieceColor.navy => navy,
      PieceColor.violet => violet,
    };
  }

  /// Gets all squares occupied by pieces of [PieceColor]s.
  SquareSet byColors(ISet<PieceColor> colors) {
    return _colorMap()
        .entries
        .where((entry) => colors.contains(entry.key))
        .fold<SquareSet>(SquareSet.empty, (prev, entry) => prev | entry.value);
  }

  /// Gets all squares occupied by [Role].
  SquareSet byRole(Role role) {
    return switch (role) {
      Role.pawn => pawns,
      Role.knight => knights,
      Role.bishop => bishops,
      Role.rook => rooks,
      Role.queen => queens,
      Role.king => kings,
    };
  }

  /// Gets all squares occupied by [Piece].
  SquareSet byPiece(Piece piece) {
    return byColor(piece.color) & byRole(piece.role);
  }

  /// Gets the [PieceColor] at this [Square], if any.
  PieceColor? colorAt(Square square) {
    for (final color in PieceColor.values) {
      if (byColor(color).has(square)) {
        return color;
      }
    }
    return null;
  }

  /// Gets the [Role] at this [Square], if any.
  Role? roleAt(Square square) {
    for (final role in Role.values) {
      if (byRole(role).has(square)) {
        return role;
      }
    }
    return null;
  }

  /// Gets the [Piece] at this [Square], if any.
  Piece? pieceAt(Square square) {
    final color = colorAt(square);
    if (color == null) {
      return null;
    }
    final role = roleAt(square)!;
    return Piece(color: color, role: role);
  }

  /// Finds the unique king [Square] of the given [Side], if any.
  Square? kingOf(Side side) {
    final color = armyManager.colorOf(side);
    return byPiece(Piece(color: color, role: Role.king)).lsb();
  }

  /// Finds the squares who are attacking `square` by the `attacker` [Side].
  SquareSet attacksTo(Square square, Side attacker, {SquareSet? occupied}) =>
      bySide(attacker).intersect(rookAttacks(square, occupied ?? this.occupied)
          .intersect(rooksAndQueens)
          .union(bishopAttacks(square, occupied ?? this.occupied)
              .intersect(bishopsAndQueens))
          .union(knightAttacks(square).intersect(knights))
          .union(kingAttacks(square).intersect(kings))
          .union(pawnAttacks(square).intersect(pawns)));

  /// Puts a [Piece] on a [Square] overriding the existing one, if any.
  Board setPieceAt(Square square, Piece piece) {
    return removePieceAt(square).copyWith(
      occupied: occupied.withSquare(square),
      white: piece.color == PieceColor.white ? white.withSquare(square) : null,
      ash: piece.color == PieceColor.ash ? ash.withSquare(square) : null,
      slate: piece.color == PieceColor.slate ? slate.withSquare(square) : null,
      black: piece.color == PieceColor.black ? black.withSquare(square) : null,
      pink: piece.color == PieceColor.pink ? pink.withSquare(square) : null,
      red: piece.color == PieceColor.red ? red.withSquare(square) : null,
      orange:
          piece.color == PieceColor.orange ? orange.withSquare(square) : null,
      yellow:
          piece.color == PieceColor.yellow ? yellow.withSquare(square) : null,
      green: piece.color == PieceColor.green ? green.withSquare(square) : null,
      cyan: piece.color == PieceColor.cyan ? cyan.withSquare(square) : null,
      navy: piece.color == PieceColor.navy ? navy.withSquare(square) : null,
      violet:
          piece.color == PieceColor.violet ? violet.withSquare(square) : null,
      pawns: piece.role == Role.pawn ? pawns.withSquare(square) : null,
      knights: piece.role == Role.knight ? knights.withSquare(square) : null,
      bishops: piece.role == Role.bishop ? bishops.withSquare(square) : null,
      rooks: piece.role == Role.rook ? rooks.withSquare(square) : null,
      queens: piece.role == Role.queen ? queens.withSquare(square) : null,
      kings: piece.role == Role.king ? kings.withSquare(square) : null,
    );
  }

  /// Removes the [Piece] at this [Square] if it exists.
  Board removePieceAt(Square square) {
    final piece = pieceAt(square);
    return piece != null
        ? copyWith(
            occupied: occupied.withoutSquare(square),
            white: piece.color == PieceColor.white
                ? white.withoutSquare(square)
                : null,
            ash: piece.color == PieceColor.ash
                ? ash.withoutSquare(square)
                : null,
            slate: piece.color == PieceColor.slate
                ? slate.withoutSquare(square)
                : null,
            black: piece.color == PieceColor.black
                ? black.withoutSquare(square)
                : null,
            pink: piece.color == PieceColor.pink
                ? pink.withoutSquare(square)
                : null,
            red: piece.color == PieceColor.red
                ? red.withoutSquare(square)
                : null,
            orange: piece.color == PieceColor.orange
                ? orange.withoutSquare(square)
                : null,
            yellow: piece.color == PieceColor.yellow
                ? yellow.withoutSquare(square)
                : null,
            green: piece.color == PieceColor.green
                ? green.withoutSquare(square)
                : null,
            cyan: piece.color == PieceColor.cyan
                ? cyan.withoutSquare(square)
                : null,
            navy: piece.color == PieceColor.navy
                ? navy.withoutSquare(square)
                : null,
            violet: piece.color == PieceColor.violet
                ? violet.withoutSquare(square)
                : null,
            pawns: piece.role == Role.pawn ? pawns.withoutSquare(square) : null,
            knights: piece.role == Role.knight
                ? knights.withoutSquare(square)
                : null,
            bishops: piece.role == Role.bishop
                ? bishops.withoutSquare(square)
                : null,
            rooks: piece.role == Role.rook ? rooks.withoutSquare(square) : null,
            queens:
                piece.role == Role.queen ? queens.withoutSquare(square) : null,
            kings: piece.role == Role.king ? kings.withoutSquare(square) : null,
          )
        : this;
  }

  /// Gets the [SquareSet] of all squares of color [PieceColor].
  SquareSet coloredSquaresOf(PieceColor color) {
    return switch (color) {
      PieceColor.white => SquareSet.whiteSquares,
      PieceColor.black => SquareSet.blackSquares,
      PieceColor.ash => SquareSet.ashSquares,
      PieceColor.slate => SquareSet.slateSquares,
      PieceColor.cyan => SquareSet.cyanSquares,
      PieceColor.green => SquareSet.greenSquares,
      PieceColor.navy => SquareSet.navySquares,
      PieceColor.orange => SquareSet.orangeSquares,
      PieceColor.pink => SquareSet.pinkSquares,
      PieceColor.red => SquareSet.redSquares,
      PieceColor.violet => SquareSet.violetSquares,
      PieceColor.yellow => SquareSet.yellowSquares,
    };
  }

  /// Gets the [Piece] at any [Square] of [PieceColor], if any.
  Piece? pieceOnSquareOf(PieceColor color) {
    return coloredSquaresOf(color)
        .squares
        .map((square) => pieceAt(square))
        .firstWhere((piece) => piece != null, orElse: () => null);
  }

  PieceColor ownedColorOf(Side side) => armyManager.colorOf(side);

  /// Returns true if the [PieceColor] belongs to the [Side].
  bool colorBelongsTo(Side side, PieceColor color) =>
      armyManager.colorsOf(side).contains(color);

  bool colorControlledBy(Side side, PieceColor color) =>
      armyManager.colorsOf(side).contains(color);

  Board setOwnedColor(Side side, PieceColor color) {
    return ownedColorOf(side) == color
        ? copyWith()
        : copyWith(armyManager: armyManager.setOwnedColor(side, color));
  }

  ISet<PieceColor> controlledColorsOf(Side side) =>
      armyManager.controlledColorsOf(side);

  Board addControlledColor(PieceColor controllerColor, PieceColor color) {
    return copyWith(
        armyManager: armyManager.addControlledArmy(controllerColor, color));
  }

  Board removeControlledColor(PieceColor color) =>
      copyWith(armyManager: armyManager.removeControlledArmy(color));

  /// Returns a copy of this board with some fields updated.
  Board copyWith({
    SquareSet? occupied,
    SquareSet? white,
    SquareSet? ash,
    SquareSet? slate,
    SquareSet? black,
    SquareSet? pink,
    SquareSet? red,
    SquareSet? orange,
    SquareSet? yellow,
    SquareSet? green,
    SquareSet? cyan,
    SquareSet? navy,
    SquareSet? violet,
    SquareSet? pawns,
    SquareSet? knights,
    SquareSet? bishops,
    SquareSet? rooks,
    SquareSet? queens,
    SquareSet? kings,
    ArmyManager? armyManager,
  }) {
    return Board(
      occupied: occupied ?? this.occupied,
      white: white ?? this.white,
      ash: ash ?? this.ash,
      slate: slate ?? this.slate,
      black: black ?? this.black,
      pink: pink ?? this.pink,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      yellow: yellow ?? this.yellow,
      green: green ?? this.green,
      cyan: cyan ?? this.cyan,
      navy: navy ?? this.navy,
      violet: violet ?? this.violet,
      pawns: pawns ?? this.pawns,
      knights: knights ?? this.knights,
      bishops: bishops ?? this.bishops,
      rooks: rooks ?? this.rooks,
      queens: queens ?? this.queens,
      kings: kings ?? this.kings,
      armyManager: armyManager ?? this.armyManager,
    );
  }
}
