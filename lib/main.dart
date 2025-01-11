import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:opensovereignchess_app/src/app.dart';
import 'package:opensovereignchess_app/src/log.dart';

void main() {
  setupLogger();
  usePathUrlStrategy();

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const Application(),
    ),
  );
}
