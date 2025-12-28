import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:iron_path_mobile/services/auth_service.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    await setUpHiveForTesting();
    // AuthService expects 'settings' box to be open or opens it? 
    // In auth_service.dart calling Hive.box('settings') requires it to be open.
    // The build() method calls Hive.box('settings').
    // So we must open it before building the container/provider.
    await Hive.openBox('settings');
    
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await tearDownHive();
  });

  test('Initial state is unauthenticated', () {
    final authState = container.read(authServiceProvider);
    expect(authState.isAuthenticated, false);
    expect(authState.isGuest, false);
  });

  test('Login updates state to authenticated', () async {
    final notifier = container.read(authServiceProvider.notifier);
    
    // Default mock login
    await notifier.login('test@test.com', 'password123');
    
    final authState = container.read(authServiceProvider);
    expect(authState.isAuthenticated, true);
    expect(authState.isGuest, false);
    expect(authState.userId, isNotNull);
    
    // Verify persistence
    final box = Hive.box('settings');
    expect(box.get('auth_uid'), isNotNull);
    expect(box.get('auth_is_guest'), false);
  });

  test('Guest login updates state to guest', () async {
    final notifier = container.read(authServiceProvider.notifier);
    
    await notifier.loginAsGuest();
    
    final authState = container.read(authServiceProvider);
    expect(authState.isAuthenticated, true);
    expect(authState.isGuest, true);
    expect(authState.userId, 'guest');
    
    final box = Hive.box('settings');
    expect(box.get('auth_is_guest'), true);
  });

  test('Logout clears state', () async {
    final notifier = container.read(authServiceProvider.notifier);
    await notifier.loginAsGuest();
    
    await notifier.logout();
    
    final authState = container.read(authServiceProvider);
    expect(authState.isAuthenticated, false);
    
    final box = Hive.box('settings');
    expect(box.get('auth_uid'), isNull);
  });
}
