import 'package:hive_flutter/hive_flutter.dart';
import '../models/enums.dart';
import '../models/user_profile.dart';
import '../models/progression_rule.dart';
import '../models/exercise.dart';
import '../models/program_day_exercise.dart';
import '../models/program_day.dart';
import '../models/program.dart';
import '../models/workout_set.dart';
import '../models/session_exercise.dart';
import '../models/workout_session.dart';
import '../models/history_entry_exercise.dart';
import '../models/history_entry.dart';

class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    void register<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    // Register Adapters
    register(UserProfileAdapter()); // Type 0
    register(ProgressionRuleAdapter()); // Type 1
    register(ExerciseAdapter()); // Type 2
    register(ProgramDayAdapter()); // Type 3
    register(ProgramAdapter()); // Type 4
    register(WorkoutSetAdapter()); // Type 5
    register(SessionExerciseAdapter()); // Type 6
    register(WorkoutSessionAdapter()); // Type 7
    register(HistoryEntryAdapter()); // Type 8
    
    // Enums
    register(UnitAdapter()); // Type 9
    register(SplitTypeAdapter()); // Type 10
    register(ProgressionTypeAdapter()); // Type 11
    register(ExperienceLevelAdapter()); // Type 12
    
    // Nested
    register(ProgramDayExerciseAdapter()); // Type 13
    register(HistoryEntryExerciseAdapter()); // Type 14
    
    // Open Boxes
    await Hive.openBox<UserProfile>('user_profile');
    await Hive.openBox<Exercise>('exercises');
    await Hive.openBox<Program>('programs');
    await Hive.openBox<HistoryEntry>('history');
    await Hive.openBox<WorkoutSession>('active_session'); // Store active session if any
    await Hive.openBox('settings'); // Auth settings
  }
}
