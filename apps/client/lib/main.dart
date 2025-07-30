import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './src/app.dart';
import './src/log.dart';

import 'firebase_options.dart';

Future<void> main() async {
  setupLogger();
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
  if (supabaseUrl == "" || supabaseAnonKey == "") {
    throw Exception('Supabase environment variables are not set.');
  }
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
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
