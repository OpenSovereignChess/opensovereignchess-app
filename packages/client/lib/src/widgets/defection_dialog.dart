import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:opensovereignchess_app/dartsovereignchess/dartsovereignchess.dart';

/// Displays a Dialog that lets the player choose which color to defect to.
Future<PieceColor?> showDefectionDialog(
  BuildContext context,
  ISet<PieceColor> colorOptions,
) async {
  return showDialog<PieceColor>(
    context: context,
    builder: (BuildContext context) => SimpleDialog(
      title: const Text('Defect to which color?'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      children: colorOptions
          .map(
            (color) => SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(color);
              },
              child: Text(color.toString()),
            ),
          )
          .toList(),
    ),
  );
}
