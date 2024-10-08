import 'package:flutter/material.dart';
import 'package:opensovereignchess_app/src/navigation.dart';

/// The main application widget.
///
/// This widget is the root of the application and is responsible for setting up
/// the theme and global settings.
class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sovereign Chess',
      home: const _EntryPointWidget(),
    );
  }
}

/// The entry point widget for the application.
///
/// This widget needs to be a descendant of [MaterialApp] to be able to handle
/// the [Navigator] properly.
///
/// This widget is responsible for setting up the adaptive navigation scaffold and
/// the main navigation routes.
class _EntryPointWidget extends StatefulWidget {
  const _EntryPointWidget();

  @override
  State<_EntryPointWidget> createState() => _EntryPointState();
}

class _EntryPointState extends State<_EntryPointWidget> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold();
  }
}
