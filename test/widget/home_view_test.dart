import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:iron_path_mobile/views/home_view.dart';
import 'package:iron_path_mobile/models/user_profile.dart';
import 'package:iron_path_mobile/models/history_entry.dart';
import 'package:iron_path_mobile/models/workout_session.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  setUp(() async {
    await setUpHiveForTesting();
    await Hive.openBox<UserProfile>('user_profile');
    await Hive.openBox<HistoryEntry>('history');
    await Hive.openBox<WorkoutSession>('active_session');
  });

  tearDown(() async {
    await tearDownHive();
  });

  testWidgets('HomeView renders standard sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeView(),
        ),
      ),
    );

    // Header
    expect(find.text('Welcome Back'), findsOneWidget);
    
    // Stats Grid
    expect(find.text('THIS WEEK'), findsOneWidget);
    expect(find.text('VOLUME'), findsOneWidget);
    
    // Recent Activity
    expect(find.text('Recent Activity'), findsOneWidget);
  });
}
