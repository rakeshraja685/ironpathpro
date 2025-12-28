import 'package:hive/hive.dart';
import 'workout_set.dart';

part 'session_exercise.g.dart';

@HiveType(typeId: 6)
class SessionExercise extends HiveObject {
  @HiveField(0)
  String exerciseId;

  @HiveField(1)
  String? progressionRuleId;

  @HiveField(2)
  List<WorkoutSet> sets;

  @HiveField(3)
  String? notes;

  SessionExercise({
    required this.exerciseId,
    this.progressionRuleId,
    required this.sets,
    this.notes,
  });
}
