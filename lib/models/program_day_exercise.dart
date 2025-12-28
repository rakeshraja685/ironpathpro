import 'package:hive/hive.dart';

part 'program_day_exercise.g.dart';

@HiveType(typeId: 13)
class ProgramDayExercise extends HiveObject {
  @HiveField(0)
  String exerciseId;

  @HiveField(1)
  int targetSets;

  @HiveField(2)
  String targetReps;

  @HiveField(3)
  String? progressionRuleId;

  ProgramDayExercise({
    required this.exerciseId,
    required this.targetSets,
    required this.targetReps,
    this.progressionRuleId,
  });
}
