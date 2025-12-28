import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:iron_path_mobile/views/active_session_view_model.dart';
import 'package:iron_path_mobile/models/program.dart';
import 'package:iron_path_mobile/models/program_day.dart';
import 'package:iron_path_mobile/models/program_day_exercise.dart';
import 'package:iron_path_mobile/models/workout_session.dart';
import 'package:iron_path_mobile/models/enums.dart';

import '../helpers/hive_test_helper.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    await setUpHiveForTesting();
    
    // Open necessary boxes
    await Hive.openBox<WorkoutSession>('active_session');
    await Hive.openBox<Program>('programs');
    await Hive.openBox<dynamic>('exercises'); // Dynamic to avoid typing issues if strict
    await Hive.openBox<dynamic>('history');

    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await tearDownHive();
  });

  test('Start session creates a valid session in Hive', () async {
    final notifier = container.read(activeSessionViewModelProvider.notifier);
    
    // Mock Data
    final day = ProgramDay(
        id: 'day1', 
        name: 'Push', 
        exercises: [
          ProgramDayExercise(exerciseId: 'ex1', targetSets: 3, targetReps: '10')
        ]
    );
    final program = Program(
        id: 'prog1', 
        name: 'PPL', 
        split: SplitType.ppl, 
        days: [day]
    );

    await notifier.startSession(program, day);
    
    final session = container.read(activeSessionViewModelProvider);
    expect(session, isNotNull);
    expect(session!.exercises.length, 1);
    expect(session.exercises.first.sets.length, 3);
    
    // Verify persistence
    final box = Hive.box<WorkoutSession>('active_session');
    expect(box.isNotEmpty, true);
    expect(box.getAt(0)!.programDayId, 'day1');
  });

  test('Add Set increases set count', () async {
    final notifier = container.read(activeSessionViewModelProvider.notifier);
    // Setup session
     final day = ProgramDay(
        id: 'day1', name: 'Push', exercises: [ProgramDayExercise(exerciseId: 'ex1', targetSets: 1, targetReps: '10')]
    );
     final program = Program(id: 'p1', name: 'Test', split: SplitType.custom, days: [day]);
     
    await notifier.startSession(program, day);
    
    // Add set
    await notifier.addSet(0);
    
    final session = container.read(activeSessionViewModelProvider);
    expect(session!.exercises[0].sets.length, 2);
  });
}
