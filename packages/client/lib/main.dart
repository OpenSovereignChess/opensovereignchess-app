import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:opensovereignchess_app/src/app.dart';
import 'package:opensovereignchess_app/src/log.dart';

import 'firebase_options.dart';

Future<void> main() async {
  setupLogger();
  usePathUrlStrategy();
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const Application(),
    ),
  );
}
