import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import './screens/board_editor_screen.dart';
import './screens/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: '/editor',
      builder: (BuildContext context, GoRouterState state) =>
          const BoardEditorScreen(),
    ),
  ],
);
