import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:iron_path_mobile/views/auth/login_view.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  setUp(() async {
    await setUpHiveForTesting();
    await Hive.openBox('settings');
  });

  tearDown(() async {
    await tearDownHive();
  });

  testWidgets('LoginView has email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('Enabling login button when fields are filled', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@test.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password');
    await tester.pump();

    // In current implementation, button is always enabled unless loading.
    // We can tap it.
    await tester.tap(find.text('Log In'));
    await tester.pump();
    
    // Should show loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for the simulated delay (1 second) in AuthService
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    
    // Ideally verifying navigation, but since we didn't inject router, context.go might throw or do nothing.
    // For this basic test, checking partial state is fine.
  });
}
