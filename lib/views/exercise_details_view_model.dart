import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'home_view_model.dart'; // To access history provider

part 'exercise_details_view_model.g.dart';

@riverpod
class ExerciseDetailsViewModel extends _$ExerciseDetailsViewModel {
  @override
  Future<List<ExerciseHistoryItem>> build(String exerciseName) async {
    final history = ref.watch(recentHistoryProvider);
    
    if (history.isEmpty) return [];

    final logs = <ExerciseHistoryItem>[];

    for (var entry in history) {
      // Find if this exercise was performed in this session
      try {
        final exerciseEntry = entry.exercises.firstWhere(
          (e) => e.name == exerciseName,
        );

        // Parse "100kg x 5"
        final parts = exerciseEntry.bestSet.split('x');
        if (parts.length == 2) {
          final weightStr = parts[0].replaceAll('kg', '').replaceAll('lb', '').trim();
          final repsStr = parts[1].trim();
          
          final weight = double.tryParse(weightStr) ?? 0;
          final reps = int.tryParse(repsStr) ?? 0;

          logs.add(ExerciseHistoryItem(
            date: DateTime.fromMillisecondsSinceEpoch(entry.date),
            weight: weight,
            reps: reps,
            oneRepMax: _calculate1RM(weight, reps),
            bestSetStr: exerciseEntry.bestSet,
          ));
        }
      } catch (e) {
        // Exercise not found in this entry, skip
      }
    }

    // Sort by date descending
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }

  double _calculate1RM(double weight, int reps) {
    if (reps == 0) return 0;
    if (reps == 1) return weight;
    // Epley formula: w * (1 + r/30)
    return weight * (1 + reps / 30.0);
  }
}

class ExerciseHistoryItem {
  final DateTime date;
  final double weight;
  final int reps;
  final double oneRepMax;
  final String bestSetStr;

  ExerciseHistoryItem({
    required this.date,
    required this.weight,
    required this.reps,
    required this.oneRepMax,
    required this.bestSetStr,
  });
}
