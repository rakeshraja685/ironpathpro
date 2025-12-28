import 'package:hive/hive.dart';

part 'history_entry_exercise.g.dart';

@HiveType(typeId: 14)
class HistoryEntryExercise extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String bestSet;

  HistoryEntryExercise({
    required this.name,
    required this.bestSet,
  });
}
