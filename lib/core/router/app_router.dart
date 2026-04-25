import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/main_navigation/presentation/screens/main_navigation_screen.dart';
import '../../features/hinario/presentation/screens/hinario_screen.dart';
import '../../features/hinario/presentation/screens/hino_detail_screen.dart';
import '../../features/hinario/presentation/screens/hino_search_screen.dart';
import '../../features/igrejas/presentation/screens/igrejas_screen.dart';
import '../../features/igrejas/presentation/screens/igreja_detalhe_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

import '../../features/igrejas/presentation/screens/edit_my_igreja_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/hinario',
    refreshListenable: null,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isAuthenticated = authState.value != null;

      // Se não autenticado e tenta aceder ao perfil
      if (!isAuthenticated && !isLoggingIn) {
        if (state.matchedLocation == '/profile' || state.matchedLocation == '/igrejas/minha-igreja') {
          return '/login';
        }
      }

      // Se autenticado e tenta ir para login/register
      if (isAuthenticated && isLoggingIn) {
        return '/hinario';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/igrejas/minha-igreja',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditMyIgrejaScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/hinario',
                builder: (context, state) => const HinarioScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const HinoSearchScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final idStr = state.pathParameters['id'];
                      final id = int.tryParse(idStr ?? '') ?? 0;
                      return HinoDetailScreen(hinoId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/igrejas',
                builder: (context, state) => const IgrejasScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final idStr = state.pathParameters['id'];
                      final id = int.tryParse(idStr ?? '') ?? 0;
                      return IgrejaDetalheScreen(igrejaId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
