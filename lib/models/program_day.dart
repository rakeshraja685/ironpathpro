import 'package:hive/hive.dart';
import 'program_day_exercise.dart';

part 'program_day.g.dart';

@HiveType(typeId: 3)
class ProgramDay extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<ProgramDayExercise> exercises;

  ProgramDay({
    required this.id,
    required this.name,
    required this.exercises,
  });
}
