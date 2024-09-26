import 'package:flutter/widgets.dart';

/// Piece color, such as white, black, etc.
///
/// We cannot conflate the piece colors with the normal chess sides, i.e.
/// black and white, since the players can switch colors during the game.
enum PieceColor {
  white,
  ash,
  slate,
  black,
  pink,
  red,
  orange,
  yellow,
  green,
  cyan,
  navy,
  violet;

  /// Gets the PieceColor from a character.
  static PieceColor? fromChar(String ch) {
    return switch (ch.toLowerCase()) {
      'w' => PieceColor.white,
      'a' => PieceColor.ash,
      's' => PieceColor.slate,
      'b' => PieceColor.black,
      'p' => PieceColor.pink,
      'r' => PieceColor.red,
      'o' => PieceColor.orange,
      'y' => PieceColor.yellow,
      'g' => PieceColor.green,
      'c' => PieceColor.cyan,
      'n' => PieceColor.navy,
      'v' => PieceColor.violet,
      _ => null,
    };
  }

  /// Gets the piece color letter in lowercase.
  String get letter => switch (this) {
        PieceColor.white => 'w',
        PieceColor.ash => 'a',
        PieceColor.slate => 's',
        PieceColor.black => 'b',
        PieceColor.pink => 'p',
        PieceColor.red => 'r',
        PieceColor.orange => 'o',
        PieceColor.yellow => 'y',
        PieceColor.green => 'g',
        PieceColor.cyan => 'c',
        PieceColor.navy => 'n',
        PieceColor.violet => 'v',
      };
}

/// Piece role, such as pawn, knight, etc.
enum Role {
  bishop,
  king,
  knight,
  pawn,
  queen,
  rook;

  /// Gets the role from a character.
  static Role? fromChar(String ch) {
    return switch (ch.toLowerCase()) {
      'b' => Role.bishop,
      'k' => Role.king,
      'n' => Role.knight,
      'p' => Role.pawn,
      'q' => Role.queen,
      'r' => Role.rook,
      _ => null,
    };
  }

  /// Gets the role letter in lowercase.
  String get letter => switch (this) {
        Role.bishop => 'b',
        Role.king => 'k',
        Role.knight => 'n',
        Role.pawn => 'p',
        Role.queen => 'q',
        Role.rook => 'r',
      };
}

/// A file of the chessboard.
extension type const File._(int value) implements int {
  /// Gets the chessboard [File] from a file index between 0 and 16.
  const File(this.value) : assert(value >= 0 && value < 16);

  /// Gets a [File] from its name in algebraic notation.
  ///
  /// Throws a [FormatException] if the algebraic notation is invalid.
  factory File.fromName(String algebraic) {
    final file = algebraic.codeUnitAt(0) - 97;
    if (file < 0 || file > 15) {
      throw FormatException('Invalid algebraic notation: $algebraic');
    }
    return File(file);
  }

  static const a = File(0);
  static const b = File(1);
  static const c = File(2);
  static const d = File(3);
  static const e = File(4);
  static const f = File(5);
  static const g = File(6);
  static const h = File(7);
  static const i = File(8);
  static const j = File(9);
  static const k = File(10);
  static const l = File(11);
  static const m = File(12);
  static const n = File(13);
  static const o = File(14);
  static const p = File(15);

  /// All files in ascending order.
  static const values = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p];

  static const _names = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p'
  ];

  /// The name of the file, such as 'a', 'b', 'c', etc.
  String get name => _names[value];
}

/// A rank of the chessboard.
extension type const Rank._(int value) implements int {
  /// Gets the chessboard [Rank] from a rank index between 0 and 16.
  const Rank(this.value) : assert(value >= 0 && value < 16);

  /// Gets a [Rank] from its name in algebraic notation.
  ///
  /// Throws a [FormatException] if the algebraic notation is invalid.
  factory Rank.fromName(String algebraic) {
    final rank = algebraic.codeUnitAt(0) - 49;
    if (rank < 0 || rank > 15) {
      throw FormatException('Invalid algebraic notation: $algebraic');
    }
    return Rank(rank);
  }

  static const first = Rank(0);
  static const second = Rank(1);
  static const third = Rank(2);
  static const fourth = Rank(3);
  static const fifth = Rank(4);
  static const sixth = Rank(5);
  static const seventh = Rank(6);
  static const eighth = Rank(7);
  static const ninth = Rank(8);
  static const tenth = Rank(9);
  static const eleventh = Rank(10);
  static const twelfth = Rank(11);
  static const thirteenth = Rank(12);
  static const fourteenth = Rank(13);
  static const fifteenth = Rank(14);
  static const sixteenth = Rank(15);

  /// All ranks in ascending order.
  static const values = [
    first,
    second,
    third,
    fourth,
    fifth,
    sixth,
    seventh,
    eighth,
    ninth,
    tenth,
    eleventh,
    twelfth,
    thirteenth,
    fourteenth,
    fifteenth,
    sixteenth,
  ];

  static const _names = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
  ];

  /// The name of the rank, such as '1', '2', '3', etc.
  String get name => _names[value];
}

/// A square of the chessboard.
///
/// The square is represented with an integer ranging from 0 to 255, using a
/// little-endian rank-file mapping (LERF):
extension type const Square._(int value) implements int {
  /// Gets the chessboard [Square] from a square index between 0 and 256.
  const Square(this.value) : assert(value >= 0 && value < 256);

  /// Gets a [Square] from its name in algebraic notation.
  ///
  /// Throws a [FormatException] if the algebraic notation is invalid.
  factory Square.fromName(String algebraic) {
    if (algebraic.length != 2) {
      throw FormatException('Invalid algebraic notation: $algebraic');
    }
    final file = algebraic.codeUnitAt(0) - 97;
    final rank = algebraic.codeUnitAt(1) - 49;
    if (file < 0 || file > 15 || rank < 0 || rank > 15) {
      throw FormatException('Invalid algebraic notation: $algebraic');
    }
    return Square(file | (rank << 3));
  }

  /// Gets a [Square] from its file and rank.
  factory Square.fromCoords(File file, Rank rank) => Square(file | (rank << 4));

  static const a1 = Square(0);
  static const b1 = Square(1);
  static const c1 = Square(2);
  static const d1 = Square(3);
  static const e1 = Square(4);
  static const f1 = Square(5);
  static const g1 = Square(6);
  static const h1 = Square(7);
  static const i1 = Square(8);
  static const j1 = Square(9);
  static const k1 = Square(10);
  static const l1 = Square(11);
  static const m1 = Square(12);
  static const n1 = Square(13);
  static const o1 = Square(14);
  static const p1 = Square(15);
  static const a2 = Square(16);
  static const b2 = Square(17);
  static const c2 = Square(18);
  static const d2 = Square(19);
  static const e2 = Square(20);
  static const f2 = Square(21);
  static const g2 = Square(22);
  static const h2 = Square(23);
  static const i2 = Square(24);
  static const j2 = Square(25);
  static const k2 = Square(26);
  static const l2 = Square(27);
  static const m2 = Square(28);
  static const n2 = Square(29);
  static const o2 = Square(30);
  static const p2 = Square(31);
  static const a3 = Square(32);
  static const b3 = Square(33);
  static const c3 = Square(34);
  static const d3 = Square(35);
  static const e3 = Square(36);
  static const f3 = Square(37);
  static const g3 = Square(38);
  static const h3 = Square(39);
  static const i3 = Square(40);
  static const j3 = Square(41);
  static const k3 = Square(42);
  static const l3 = Square(43);
  static const m3 = Square(44);
  static const n3 = Square(45);
  static const o3 = Square(46);
  static const p3 = Square(47);
  static const a4 = Square(48);
  static const b4 = Square(49);
  static const c4 = Square(50);
  static const d4 = Square(51);
  static const e4 = Square(52);
  static const f4 = Square(53);
  static const g4 = Square(54);
  static const h4 = Square(55);
  static const i4 = Square(56);
  static const j4 = Square(57);
  static const k4 = Square(58);
  static const l4 = Square(59);
  static const m4 = Square(60);
  static const n4 = Square(61);
  static const o4 = Square(62);
  static const p4 = Square(63);
  static const a5 = Square(64);
  static const b5 = Square(65);
  static const c5 = Square(66);
  static const d5 = Square(67);
  static const e5 = Square(68);
  static const f5 = Square(69);
  static const g5 = Square(70);
  static const h5 = Square(71);
  static const i5 = Square(72);
  static const j5 = Square(73);
  static const k5 = Square(74);
  static const l5 = Square(75);
  static const m5 = Square(76);
  static const n5 = Square(77);
  static const o5 = Square(78);
  static const p5 = Square(79);
  static const a6 = Square(80);
  static const b6 = Square(81);
  static const c6 = Square(82);
  static const d6 = Square(83);
  static const e6 = Square(84);
  static const f6 = Square(85);
  static const g6 = Square(86);
  static const h6 = Square(87);
  static const i6 = Square(88);
  static const j6 = Square(89);
  static const k6 = Square(90);
  static const l6 = Square(91);
  static const m6 = Square(92);
  static const n6 = Square(93);
  static const o6 = Square(94);
  static const p6 = Square(95);
  static const a7 = Square(96);
  static const b7 = Square(97);
  static const c7 = Square(98);
  static const d7 = Square(99);
  static const e7 = Square(100);
  static const f7 = Square(101);
  static const g7 = Square(102);
  static const h7 = Square(103);
  static const i7 = Square(104);
  static const j7 = Square(105);
  static const k7 = Square(106);
  static const l7 = Square(107);
  static const m7 = Square(108);
  static const n7 = Square(109);
  static const o7 = Square(110);
  static const p7 = Square(111);
  static const a8 = Square(112);
  static const b8 = Square(113);
  static const c8 = Square(114);
  static const d8 = Square(115);
  static const e8 = Square(116);
  static const f8 = Square(117);
  static const g8 = Square(118);
  static const h8 = Square(119);
  static const i8 = Square(120);
  static const j8 = Square(121);
  static const k8 = Square(122);
  static const l8 = Square(123);
  static const m8 = Square(124);
  static const n8 = Square(125);
  static const o8 = Square(126);
  static const p8 = Square(127);
  static const a9 = Square(128);
  static const b9 = Square(129);
  static const c9 = Square(130);
  static const d9 = Square(131);
  static const e9 = Square(132);
  static const f9 = Square(133);
  static const g9 = Square(134);
  static const h9 = Square(135);
  static const i9 = Square(136);
  static const j9 = Square(137);
  static const k9 = Square(138);
  static const l9 = Square(139);
  static const m9 = Square(140);
  static const n9 = Square(141);
  static const o9 = Square(142);
  static const p9 = Square(143);
  static const a10 = Square(144);
  static const b10 = Square(145);
  static const c10 = Square(146);
  static const d10 = Square(147);
  static const e10 = Square(148);
  static const f10 = Square(149);
  static const g10 = Square(150);
  static const h10 = Square(151);
  static const i10 = Square(152);
  static const j10 = Square(153);
  static const k10 = Square(154);
  static const l10 = Square(155);
  static const m10 = Square(156);
  static const n10 = Square(157);
  static const o10 = Square(158);
  static const p10 = Square(159);
  static const a11 = Square(160);
  static const b11 = Square(161);
  static const c11 = Square(162);
  static const d11 = Square(163);
  static const e11 = Square(164);
  static const f11 = Square(165);
  static const g11 = Square(166);
  static const h11 = Square(167);
  static const i11 = Square(168);
  static const j11 = Square(169);
  static const k11 = Square(170);
  static const l11 = Square(171);
  static const m11 = Square(172);
  static const n11 = Square(173);
  static const o11 = Square(174);
  static const p11 = Square(175);
  static const a12 = Square(176);
  static const b12 = Square(177);
  static const c12 = Square(178);
  static const d12 = Square(179);
  static const e12 = Square(180);
  static const f12 = Square(181);
  static const g12 = Square(182);
  static const h12 = Square(183);
  static const i12 = Square(184);
  static const j12 = Square(185);
  static const k12 = Square(186);
  static const l12 = Square(187);
  static const m12 = Square(188);
  static const n12 = Square(189);
  static const o12 = Square(190);
  static const p12 = Square(191);
  static const a13 = Square(192);
  static const b13 = Square(193);
  static const c13 = Square(194);
  static const d13 = Square(195);
  static const e13 = Square(196);
  static const f13 = Square(197);
  static const g13 = Square(198);
  static const h13 = Square(199);
  static const i13 = Square(200);
  static const j13 = Square(201);
  static const k13 = Square(202);
  static const l13 = Square(203);
  static const m13 = Square(204);
  static const n13 = Square(205);
  static const o13 = Square(206);
  static const p13 = Square(207);
  static const a14 = Square(208);
  static const b14 = Square(209);
  static const c14 = Square(210);
  static const d14 = Square(211);
  static const e14 = Square(212);
  static const f14 = Square(213);
  static const g14 = Square(214);
  static const h14 = Square(215);
  static const i14 = Square(216);
  static const j14 = Square(217);
  static const k14 = Square(218);
  static const l14 = Square(219);
  static const m14 = Square(220);
  static const n14 = Square(221);
  static const o14 = Square(222);
  static const p14 = Square(223);
  static const a15 = Square(224);
  static const b15 = Square(225);
  static const c15 = Square(226);
  static const d15 = Square(227);
  static const e15 = Square(228);
  static const f15 = Square(229);
  static const g15 = Square(230);
  static const h15 = Square(231);
  static const i15 = Square(232);
  static const j15 = Square(233);
  static const k15 = Square(234);
  static const l15 = Square(235);
  static const m15 = Square(236);
  static const n15 = Square(237);
  static const o15 = Square(238);
  static const p15 = Square(239);
  static const a16 = Square(240);
  static const b16 = Square(241);
  static const c16 = Square(242);
  static const d16 = Square(243);
  static const e16 = Square(244);
  static const f16 = Square(245);
  static const g16 = Square(246);
  static const h16 = Square(247);
  static const i16 = Square(248);
  static const j16 = Square(249);
  static const k16 = Square(250);
  static const l16 = Square(251);
  static const m16 = Square(252);
  static const n16 = Square(253);
  static const o16 = Square(254);
  static const p16 = Square(255);

  /// All squares on the chessboard, from a1 to p16.
  static const values = [
    a1, b1, c1, d1, e1, f1, g1, h1, j1, k1, l1, m1, n1, o1, p1,
    a2, b2, c2, d2, e2, f2, g2, h2, j2, k2, l2, m2, n2, o2, p2,
    a3, b3, c3, d3, e3, f3, g3, h3, j3, k3, l3, m3, n3, o3, p3,
    a4, b4, c4, d4, e4, f4, g4, h4, j4, k4, l4, m4, n4, o4, p4,
    a5, b5, c5, d5, e5, f5, g5, h5, j5, k5, l5, m5, n5, o5, p5,
    a6, b6, c6, d6, e6, f6, g6, h6, j6, k6, l6, m6, n6, o6, p6,
    a7, b7, c7, d7, e7, f7, g7, h7, j7, k7, l7, m7, n7, o7, p7,
    a8, b8, c8, d8, e8, f8, g8, h8, j8, k8, l8, m8, n8, o8, p8,
    a9, b9, c9, d9, e9, f9, g9, h9, j9, k9, l9, m9, n9, o9, p9,
    a10, b10, c10, d10, e10, f10, g10, h10, j10, k10, l10, m10, n10, o10, p10,
    a11, b11, c11, d11, e11, f11, g11, h11, j11, k11, l11, m11, n11, o11, p11,
    a12, b12, c12, d12, e12, f12, g12, h12, j12, k12, l12, m12, n12, o12, p12,
    a13, b13, c13, d13, e13, f13, g13, h13, j13, k13, l13, m13, n13, o13, p13,
    a14, b14, c14, d14, e14, f14, g14, h14, j14, k14, l14, m14, n14, o14, p14,
    a15, b15, c15, d15, e15, f15, g15, h15, j15, k15, l15, m15, n15, o15, p15,
    a16, b16, c16, d16, e16, f16, g16, h16, j16, k16, l16, m16, n16, o16, p16,
  ];

  /// The file of the square on the board.
  File get file => File(value & 0xf);

  /// The rank of the square on the board.
  Rank get rank => Rank(value >> 4);

  /// Unique identifier of the square, using pure algebraic notation.
  String get name => file.name + rank.name;
}

/// Represents a piece kind, which is a tuple of color and role.
typedef PieceKind = (PieceColor color, Role role);

/// Describes a chess piece by its color, role and promotion status.
@immutable
class Piece {
  const Piece({
    required this.color,
    required this.role,
    this.promoted = false,
  });

  final PieceColor color;
  final Role role;
  final bool promoted;

  /// Gets the piece kind, which is a tuple of color and role.
  PieceKind get kind => (color, role);

  /// Gets the FEN string of this piece.
  String get fenStr {
    String s = color.letter + role.letter;
    if (promoted) {
      s += '~';
    }
    return s;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Piece &&
            other.runtimeType == runtimeType &&
            color == other.color &&
            role == other.role &&
            promoted == other.promoted;
  }

  @override
  int get hashCode => Object.hash(color, role, promoted);
}

/// Base class for a chess move.
///
/// A move can be either a [NormalMove] or a [DropMove].
@immutable
sealed class Move {
  const Move({
    required this.to,
  });

  /// The target square of this move.
  final Square to;
}

/// Represents a chess move, which is possibly a promotion.
@immutable
class NormalMove extends Move {
  const NormalMove({
    required this.from,
    required super.to,
    this.promotion,
  });

  /// The origin square of this move.
  final Square from;

  /// The role of the promoted piece, if any.
  final Role? promotion;
}

/// The white pawn piece kind.
const PieceKind kWhitePawnKind = (PieceColor.white, Role.pawn);

/// The black rook piece kind.
const PieceKind kBlackRookKind = (PieceColor.black, Role.rook);
