import 'package:cloudflare_turnstile/cloudflare_turnstile.dart'
    show CloudflareTurnstile, TurnstileOptions, TurnstileSize, TurnstileTheme;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';

class CreateGameScreen extends ConsumerWidget {
  const CreateGameScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start a new game',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You can invite others to play by sharing the game link.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const StartGameButton(),
          ],
        ),
      ),
    );
  }
}

class StartGameButton extends ConsumerStatefulWidget {
  const StartGameButton({super.key});

  @override
  ConsumerState<StartGameButton> createState() => _StartGameButtonState();
}

class _StartGameButtonState extends ConsumerState<StartGameButton> {
  bool _isTokenReceived = false; // Has user passed the CAPTCHA?
  bool _isSignedIn = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final options = TurnstileOptions(
      size: TurnstileSize.normal,
      theme: TurnstileTheme.light,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CloudflareTurnstile(
            siteKey: const String.fromEnvironment('TURNSTILE_SITE_KEY',
                defaultValue: 'your-site-key'),
            baseUrl: const String.fromEnvironment('BASE_URL',
                defaultValue: 'http://localhost'),
            options: options,
            onTokenReceived: (String token) {
              print('Turnstile success');
              setState(() {
                _isTokenReceived = true;
              });
            },
            onTokenExpired: () {
              print('Turnstile token expired');
              setState(() {
                _isTokenReceived = false;
              });
            },
          ),
        ),

        // Sign in button
        if (!_isSignedIn) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isTokenReceived && !_isLoading
                  ? () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        print('Signiing in anonymously...');
                        await ref
                            .read(authServiceProvider.notifier)
                            .signInAnonymously();
                        print('Sign in successful');
                        setState(() {
                          _isSignedIn = true;
                        });
                      } catch (e) {
                        print('Sign in failed: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign in'),
            ),
          ),
        ],

        // Create game button
        if (_isSignedIn) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: !_isLoading
                  ? () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        print('Getting current session...');
                        final session = ref
                            .read(authServiceProvider.notifier)
                            .currentSession;

                        if (session != null) {
                          print(
                              'Creating game with token: ${session.accessToken}');
                          await ref
                              .read(gameServiceProvider.notifier)
                              .createGame(session.accessToken);
                          print('Game created successfully');
                        } else {
                          throw Exception('No session found');
                        }
                      } catch (e) {
                        print('Create game failed: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Start game'),
            ),
          ),
        ],
      ],
    );
  }
}
