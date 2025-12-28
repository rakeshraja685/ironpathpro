import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'views/scaffold_with_nav_bar.dart';
import 'views/home_view.dart';
import 'views/programs_view.dart';
import 'views/program_builder_view.dart';
import 'views/active_session_view.dart';
import 'views/profile_view.dart';
import 'views/history_view.dart';
import 'views/exercise_details_view.dart';
import 'models/exercise.dart';
import 'models/program.dart';
import 'services/auth_service.dart';
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'views/auth/onboarding_view.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  // Create a Listenable that notifies when auth state changes
  final authListenable = ValueNotifier<bool>(false);
  
  ref.listen(authServiceProvider, (_, next) {
    authListenable.value = !authListenable.value; // Toggle to trigger notification
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authListenable, 
    
    redirect: (context, state) {
      final authState = ref.read(authServiceProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/login') || 
                          state.matchedLocation.startsWith('/register') || 
                          state.matchedLocation.startsWith('/onboarding');
      
      if (!isLoggedIn && !isAuthRoute) {
        return '/onboarding';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterView()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: '/programs',
            builder: (context, state) => const ProgramsView(),
            routes: [
              GoRoute(
                path: 'new',
                parentNavigatorKey: _rootNavigatorKey, // Hide bottom nav
                builder: (context, state) {
                  final program = state.extra as Program?;
                  return ProgramBuilderView(existingProgram: program);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/session',
            builder: (context, state) => const ActiveSessionView(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryView(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileView(),
          ),
          GoRoute(
            path: '/exercise',
            builder: (context, state) {
              final exercise = state.extra as Exercise;
              return ExerciseDetailsView(exercise: exercise);
            },
          ),
        ],
      ),
    ],
  );
}
