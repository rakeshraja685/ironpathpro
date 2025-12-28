import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/program.dart';
import '../models/exercise.dart';
import '../utils/default_data.dart';


part 'programs_view_model.g.dart';

@riverpod
class ProgramsViewModel extends _$ProgramsViewModel {
  @override
  List<Program> build() {
    final box = Hive.box<Program>('programs');
    
    if (box.isEmpty) {
      _seedDefaults();
    }
    
    return box.values.toList();
  }

  void _seedDefaults() {
    final programBox = Hive.box<Program>('programs');
    // Seed Program
    programBox.put(DefaultData.pplProgram.id, DefaultData.pplProgram);

    // Seed Exercises if empty
    final exerciseBox = Hive.box<Exercise>('exercises');
    if (exerciseBox.isEmpty) {
      for (final exercise in DefaultData.exercises) {
        exerciseBox.put(exercise.id, exercise);
      }
    }
  }

  Future<void> deleteProgram(String id) async {
    final box = Hive.box<Program>('programs');
    final key = box.keys.firstWhere((k) => box.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await box.delete(key);
      ref.invalidateSelf();
    }
  }
}

// Separate provider for program details if needed, but managing full list is fine for small apps
