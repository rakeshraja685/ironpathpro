import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 2)
class Exercise extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String muscle;

  @HiveField(3)
  String equipment;

  @HiveField(4)
  String defaultRuleId;

  Exercise({
    required this.id,
    required this.name,
    required this.muscle,
    required this.equipment,
    required this.defaultRuleId,
  });
}
