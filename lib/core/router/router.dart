import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/verify_code_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/leagues/presentation/hub_screen.dart';
import '../../features/draft/presentation/draft_room_screen.dart';
import '../../features/team/presentation/manage_team_screen.dart';
import '../../features/leagues/presentation/create_league_screen.dart';
import '../../features/leagues/presentation/league_config_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

part 'router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(
      authControllerProvider,
      (_, __) => notifyListeners(),
    );
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final notifier = RouterNotifier(ref);
  
  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.isLoading ? false : authState.value != null;
      final location = state.matchedLocation;
      
      final isAuthRoute = location == '/login' || 
                          location == '/register' ||
                          location == '/resetPassword';
      
      final isVerifyRoute = location == '/verify-code';

      if (authState.isLoading) return null; 

      if (!isLoggedIn && !isAuthRoute && !isVerifyRoute) {
        return '/login';
      }
      
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-code',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final managerName = state.uri.queryParameters['name'] ?? '';
          return VerifyCodeScreen(email: email, managerName: managerName);
        },
      ),
      GoRoute(
        path: '/resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HubScreen(),
      ),
      GoRoute(
        path: '/draft/:id',
        builder: (context, state) => DraftRoomScreen(leagueId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/team/:leagueId',
        builder: (context, state) => ManageTeamScreen(leagueId: state.pathParameters['leagueId']!),
      ),
      GoRoute(
        path: '/create-league',
        builder: (context, state) => const CreateLeagueScreen(),
      ),
      GoRoute(
        path: '/create-league/config',
        builder: (context, state) => LeagueConfigScreen(leagueId: state.extra as String),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        // Add slide transition
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
