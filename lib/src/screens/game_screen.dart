import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation.dart';
import '../services/auth_service.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Screen Content',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(authServiceProvider.notifier).signInAnonymously();
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
