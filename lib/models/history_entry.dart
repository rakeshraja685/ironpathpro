import 'package:hive/hive.dart';
import 'history_entry_exercise.dart';

part 'history_entry.g.dart';

@HiveType(typeId: 8)
class HistoryEntry extends HiveObject {
  @HiveField(0)
  String sessionId;

  @HiveField(1)
  int date;

  @HiveField(2)
  String programName;

  @HiveField(3)
  String dayName;

  @HiveField(4)
  double totalVolume;

  @HiveField(5)
  double? bodyWeight;

  @HiveField(6)
  List<HistoryEntryExercise> exercises;

  HistoryEntry({
    required this.sessionId,
    required this.date,
    required this.programName,
    required this.dayName,
    required this.totalVolume,
    this.bodyWeight,
    required this.exercises,
  });
}
