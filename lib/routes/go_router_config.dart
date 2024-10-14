import 'package:bubblebrain/feature/core/presentation/screens/core_screen.dart';
import 'package:bubblebrain/feature/map/models/mind_map.dart';
import 'package:bubblebrain/feature/map/presentation/screens/create_map_screen.dart';
import 'package:bubblebrain/feature/map/presentation/screens/edit_map_screen.dart';
import 'package:bubblebrain/feature/map/presentation/screens/maid_map_screen.dart';
import 'package:bubblebrain/feature/settings/privicy_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart' show RouteValue;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _mapNavigatorKey = GlobalKey<NavigatorState>();

GoRouter globalRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state, navigationShell) {
        return slideTransition(
          state: state,
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _mapNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.mindMap.path,
              pageBuilder: (context, state) =>
                  slideTransition(state: state, child: MindMapListScreen()),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _mapNavigatorKey,
                  path: RouteValue.mindMapCreate.path,
                  pageBuilder: (context, state) => slideTransition(
                    state: state,
                    child: CreateMindMapScreen(),
                  ),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _mapNavigatorKey,
                      path: RouteValue.mindMapEdit.path,
                      pageBuilder: (context, state) => slideTransition(
                        state: state,
                        child: EditMindMapScreen(
                          map: state.extra! as MindMap,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen(key: UniqueKey());
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RouteValue.privicy.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: PrivicyScreen(
            key: UniqueKey(),
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RouteValue.coreScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: CoreScreen(
            key: UniqueKey(),
          ),
        );
      },
    ),
  ],
);

Page slideTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    child: child,
    key: state.pageKey,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      );

      return SlideTransition(
        position: offsetAnimation,
        child: Stack(
          children: [
            child,
          ],
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}
