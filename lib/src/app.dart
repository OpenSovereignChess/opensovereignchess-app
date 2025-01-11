import 'package:flutter/material.dart';
import 'package:opensovereignchess_app/src/navigation.dart';

import './router.dart';

/// The main application widget.
///
/// This widget is the root of the application and is responsible for setting up
/// the theme and global settings.
class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sovereign Chess',
      routerConfig: router,
    );
  }
}
