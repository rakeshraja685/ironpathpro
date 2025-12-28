import 'package:hive/hive.dart';
import 'enums.dart';

part 'progression_rule.g.dart';

@HiveType(typeId: 1)
class ProgressionRule extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  ProgressionType type;

  @HiveField(2)
  int minReps;

  @HiveField(3)
  int maxReps;

  @HiveField(4)
  double increment;

  @HiveField(5)
  double decrement;

  @HiveField(6)
  double rpeThreshold;

  @HiveField(7)
  String? name;

  ProgressionRule({
    required this.id,
    required this.type,
    required this.minReps,
    required this.maxReps,
    required this.increment,
    required this.decrement,
    required this.rpeThreshold,
    this.name,
  });
}
