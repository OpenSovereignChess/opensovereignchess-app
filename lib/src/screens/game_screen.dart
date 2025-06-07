import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';

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
              onPressed: () async {
                final user =
                    await ref.read(authServiceProvider.notifier).currentUser;
                if (user == null) {
                  print('User is not logged in, signing in anonymously...');
                  await ref
                      .read(authServiceProvider.notifier)
                      .signInAnonymously();
                } else {
                  print('User is logged in...');
                }
                print('Creating game...');
                await ref.read(gameServiceProvider.notifier).createGame(
                      (await ref
                              .read(authServiceProvider.notifier)
                              .currentUser)!
                          .id,
                    );
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
