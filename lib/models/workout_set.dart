import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 5)
class WorkoutSet extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int setNumber;

  @HiveField(2)
  double weight;

  @HiveField(3)
  int reps;

  @HiveField(4)
  double rpe;

  @HiveField(5)
  bool completed;

  @HiveField(6)
  bool isWarmup;

  WorkoutSet({
    required this.id,
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.rpe,
    required this.completed,
    required this.isWarmup,
  });
}
