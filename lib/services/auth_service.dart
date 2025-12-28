import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart'; // We'll link auth to profile eventually

part 'auth_service.g.dart';

// Simple Mock Auth State
class AuthState {
  final bool isAuthenticated;
  final bool isGuest;
  final String? userId;

  AuthState({
    required this.isAuthenticated,
    required this.isGuest,
    this.userId,
  });

  factory AuthState.unauthenticated() => AuthState(isAuthenticated: false, isGuest: false);
  factory AuthState.guest() => AuthState(isAuthenticated: true, isGuest: true, userId: 'guest');
  factory AuthState.authenticated(String uid) => AuthState(isAuthenticated: true, isGuest: false, userId: uid);
}

@riverpod
class AuthService extends _$AuthService {
  @override
  AuthState build() {
    // Load persisted state from Hive if available
    final box = Hive.box('settings'); // Generic settings box
    final uid = box.get('auth_uid');
    final isGuest = box.get('auth_is_guest', defaultValue: false);

    if (uid != null) {
      if (isGuest) return AuthState.guest();
      return AuthState.authenticated(uid);
    }
    
    return AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    // Mock login
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    if (email.isNotEmpty && password.length >= 6) {
      final uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
      await _persistSession(uid, false);
      state = AuthState.authenticated(uid);
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> register(String email, String password) async {
     await Future.delayed(const Duration(seconds: 1));
     if (email.isNotEmpty && password.length >= 6) {
        final uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
        await _persistSession(uid, false);
        state = AuthState.authenticated(uid);
     } else {
       throw Exception('Invalid details');
     }
  }

  Future<void> loginAsGuest() async {
    await _persistSession('guest', true);
    state = AuthState.guest();
  }

  Future<void> logout() async {
    final box = Hive.box('settings');
    await box.delete('auth_uid');
    await box.delete('auth_is_guest');
    state = AuthState.unauthenticated();
  }

  Future<void> _persistSession(String uid, bool isGuest) async {
    final box = Hive.box('settings');
    await box.put('auth_uid', uid);
    await box.put('auth_is_guest', isGuest);
  }
}
