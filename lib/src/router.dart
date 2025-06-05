import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import './screens/board_editor_screen.dart';
import './screens/game_screen.dart';
import './screens/home_screen.dart';

final router = GoRouter(
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        String? fen = state.uri.queryParameters['fen'];
        fen = fen?.replaceAll('_', ' ');
        return HomeScreen(initialFen: fen);
      },
    ),
    GoRoute(
      path: '/editor',
      builder: (BuildContext context, GoRouterState state) {
        String? fen = state.uri.queryParameters['fen'];
        fen = fen?.replaceAll('_', ' ');
        return BoardEditorScreen(initialFen: fen);
      },
    ),
    GoRoute(
      path: '/games',
      builder: (BuildContext context, GoRouterState state) {
        return GameScreen();
      },
    ),
  ],
);
