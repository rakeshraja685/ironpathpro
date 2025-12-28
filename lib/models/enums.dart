import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 9)
enum Unit {
  @HiveField(0)
  kg,
  @HiveField(1)
  lb,
}

@HiveType(typeId: 10)
enum SplitType {
  @HiveField(0)
  ppl,
  @HiveField(1)
  upperLower,
  @HiveField(2)
  fullBody,
  @HiveField(3)
  broSplit,
  @HiveField(4)
  custom,
}

@HiveType(typeId: 11)
enum ProgressionType {
  @HiveField(0)
  double,
  @HiveField(1)
  linear,
  @HiveField(2)
  repTarget,
}

@HiveType(typeId: 12)
enum ExperienceLevel {
  @HiveField(0)
  beginner,
  @HiveField(1)
  intermediate,
  @HiveField(2)
  advanced,
}
