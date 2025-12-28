import 'package:hive/hive.dart';
import 'session_exercise.dart';

part 'workout_session.g.dart';

@HiveType(typeId: 7)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String programDayId;

  @HiveField(2)
  int date;

  @HiveField(3)
  int durationSec;

  @HiveField(4)
  List<SessionExercise> exercises;

  @HiveField(5)
  bool completed;

  @HiveField(6)
  double? bodyWeight;

  WorkoutSession({
    required this.id,
    required this.programDayId,
    required this.date,
    required this.durationSec,
    required this.exercises,
    required this.completed,
    this.bodyWeight,
  });
}
