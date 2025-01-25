import 'package:fast_immutable_collections/fast_immutable_collections.dart'; // For testing purposes
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:opensovereignchess_app/chessboard/chessboard.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

part 'board_editor_controller.freezed.dart';
part 'board_editor_controller.g.dart';

@riverpod
class BoardEditorController extends _$BoardEditorController {
  @override
  BoardEditorState build(String? initialFen) {
    final setup = Setup.parseFen(initialFen ?? kInitialFEN);
    return BoardEditorState(
      orientation: Side.player1,
      sideToPlay: Side.player1,
      pieces: readFen(initialFen ?? kInitialFEN).lock,
      armyManager: setup.armyManager,
      //castlingRights: IMap(const {
      //  CastlingRight.whiteKing: true,
      //  CastlingRight.whiteQueen: true,
      //  CastlingRight.blackKing: true,
      //  CastlingRight.blackQueen: true,
      //}),
      editorPointerMode: EditorPointerMode.drag,
      pieceToAddOnEdit: null,
      ply: setup.ply,
    );
  }

  void updateMode(EditorPointerMode mode, [Piece? pieceToAddOnEdit]) {
    state = state.copyWith(
        editorPointerMode: mode, pieceToAddOnEdit: pieceToAddOnEdit);
  }

  void discardPiece(Square square) {
    _updatePosition(state.pieces.remove(square));
  }

  void movePiece(Square? origin, Square destination, Piece piece) {
    if (origin != destination) {
      _updatePosition(
          state.pieces.remove(origin ?? destination).add(destination, piece));
    }
  }

  void editSquare(Square square) {
    final piece = state.pieceToAddOnEdit;
    if (piece != null) {
      _updatePosition(state.pieces.add(square, piece));
    } else {
      discardPiece(square);
    }
  }

  void flipBoard() {
    state = state.copyWith(orientation: state.orientation.opposite);
  }

  void setSideToPlay(Side side) {
    state = state.copyWith(
      sideToPlay: side,
    );
  }

  void loadFen(String fen) {
    _updatePosition(readFen(fen).lock);
  }

  void _updatePosition(IMap<Square, Piece> pieces) {
    state = state.copyWith(
      pieces: pieces,
    );
  }

  //void setCastling(Side side, CastlingSide castlingSide, bool allowed) {
  //  switch (side) {
  //    case Side.white:
  //      switch (castlingSide) {
  //        case CastlingSide.king:
  //          state = state.copyWith(
  //            castlingRights: state.castlingRights.add(CastlingRight.whiteKing, allowed),
  //          );
  //        case CastlingSide.queen:
  //          state = state.copyWith(
  //            castlingRights: state.castlingRights.add(CastlingRight.whiteQueen, allowed),
  //          );
  //      }
  //    case Side.black:
  //      switch (castlingSide) {
  //        case CastlingSide.king:
  //          state = state.copyWith(
  //            castlingRights: state.castlingRights.add(CastlingRight.blackKing, allowed),
  //          );
  //        case CastlingSide.queen:
  //          state = state.copyWith(
  //            castlingRights: state.castlingRights.add(CastlingRight.blackQueen, allowed),
  //          );
  //      }
  //  }
  //}
}

//enum CastlingRight { whiteKing, whiteQueen, blackKing, blackQueen }

@freezed
class BoardEditorState with _$BoardEditorState {
  const BoardEditorState._();

  const factory BoardEditorState({
    required Side orientation,
    required Side sideToPlay,
    required IMap<Square, Piece> pieces,
    required ArmyManager armyManager,
    //required IMap<CastlingRight, bool> castlingRights,
    required EditorPointerMode editorPointerMode,
    required int ply,

    /// When null, clears squares when in edit mode. Has no effect in drag mode.
    required Piece? pieceToAddOnEdit,
  }) = _BoardEditorState;

  //bool isCastlingAllowed(Side side, CastlingSide castlingSide) => switch (side) {
  //  Side.white => switch (castlingSide) {
  //    CastlingSide.king => castlingRights[CastlingRight.whiteKing]!,
  //    CastlingSide.queen => castlingRights[CastlingRight.whiteQueen]!,
  //  },
  //  Side.black => switch (castlingSide) {
  //    CastlingSide.king => castlingRights[CastlingRight.blackKing]!,
  //    CastlingSide.queen => castlingRights[CastlingRight.blackQueen]!,
  //  },
  //};

  ///// Returns the castling rights part of the FEN string.
  /////
  ///// If the rook is missing on one side of the king, or the king is missing on the
  ///// backrank, the castling right is removed.
  //String get _castlingRightsPart {
  //  final parts = <String>[];
  //  final Map<CastlingRight, bool> hasRook = {};
  //  final Board board = Board.parseFen(writeFen(pieces.unlock));
  //  for (final side in Side.values) {
  //    final backrankKing = SquareSet.backrankOf(side) & board.kings;
  //    final rooksAndKings =
  //        (board.bySide(side) & SquareSet.backrankOf(side)) & (board.rooks | board.kings);
  //    for (final castlingSide in CastlingSide.values) {
  //      final candidate =
  //          castlingSide == CastlingSide.king
  //              ? rooksAndKings.squares.lastOrNull
  //              : rooksAndKings.squares.firstOrNull;
  //      final isCastlingPossible =
  //          candidate != null && board.rooks.has(candidate) && backrankKing.singleSquare != null;
  //      switch ((side, castlingSide)) {
  //        case (Side.white, CastlingSide.king):
  //          hasRook[CastlingRight.whiteKing] = isCastlingPossible;
  //        case (Side.white, CastlingSide.queen):
  //          hasRook[CastlingRight.whiteQueen] = isCastlingPossible;
  //        case (Side.black, CastlingSide.king):
  //          hasRook[CastlingRight.blackKing] = isCastlingPossible;
  //        case (Side.black, CastlingSide.queen):
  //          hasRook[CastlingRight.blackQueen] = isCastlingPossible;
  //      }
  //    }
  //  }
  //  for (final right in CastlingRight.values) {
  //    if (hasRook[right]! && castlingRights[right]!) {
  //      switch (right) {
  //        case CastlingRight.whiteKing:
  //          parts.add('K');
  //        case CastlingRight.whiteQueen:
  //          parts.add('Q');
  //        case CastlingRight.blackKing:
  //          parts.add('k');
  //        case CastlingRight.blackQueen:
  //          parts.add('q');
  //      }
  //    }
  //  }
  //  return parts.isEmpty ? '-' : parts.join('');
  //}

  Piece? get activePieceOnEdit =>
      editorPointerMode == EditorPointerMode.edit ? pieceToAddOnEdit : null;

  bool get deletePiecesActive =>
      editorPointerMode == EditorPointerMode.edit && pieceToAddOnEdit == null;

  String get fen {
    final boardFen = writeFen(pieces.unlock);
    return '$boardFen ${sideToPlay == Side.player1 ? '1' : '2'} ${armyManager.fenStr} $ply';
  }
}
