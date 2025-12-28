import 'package:hive/hive.dart';
import 'enums.dart';
import 'program_day.dart';

part 'program.g.dart';

@HiveType(typeId: 4)
class Program extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  SplitType split;

  @HiveField(3)
  List<ProgramDay> days;

  Program({
    required this.id,
    required this.name,
    required this.split,
    required this.days,
  });
}
