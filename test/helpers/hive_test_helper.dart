import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

// Import all models
import 'package:iron_path_mobile/models/user_profile.dart';
import 'package:iron_path_mobile/models/enums.dart';
import 'package:iron_path_mobile/models/exercise.dart';
import 'package:iron_path_mobile/models/workout_session.dart';
import 'package:iron_path_mobile/models/session_exercise.dart';
import 'package:iron_path_mobile/models/workout_set.dart';
import 'package:iron_path_mobile/models/program.dart';
import 'package:iron_path_mobile/models/program_day.dart';
import 'package:iron_path_mobile/models/program_day_exercise.dart';
import 'package:iron_path_mobile/models/history_entry.dart';
import 'package:iron_path_mobile/models/history_entry_exercise.dart';
import 'package:iron_path_mobile/models/progression_rule.dart';


import 'dart:io';

Future<void> setUpHiveForTesting() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Use a unique temp path for Hive in each test suite to avoid conflicts
  final tempDir = await Directory.systemTemp.createTemp('hive_test_${DateTime.now().microsecondsSinceEpoch}_');
  Hive.init(tempDir.path);
  
  void register<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
  
  // Register all adapters
  register(UserProfileAdapter());
  register(ExerciseAdapter());
  register(WorkoutSessionAdapter());
  register(SessionExerciseAdapter());
  register(WorkoutSetAdapter());
  register(ProgramAdapter());
  register(ProgramDayAdapter());
  register(ProgramDayExerciseAdapter());
  register(HistoryEntryAdapter());
  register(HistoryEntryExerciseAdapter());
  register(ProgressionRuleAdapter());
  
  // Enums
  register(UnitAdapter());
  register(SplitTypeAdapter());
  register(ProgressionTypeAdapter());
  register(ExperienceLevelAdapter());

  // Clean start
  await Hive.deleteFromDisk();
}

Future<void> tearDownHive() async {
  await Hive.deleteFromDisk();
}
