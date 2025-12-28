import 'package:hive/hive.dart';
import 'enums.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Unit unit;

  @HiveField(2)
  ExperienceLevel experience;

  @HiveField(3)
  String? profileImagePath;

  UserProfile({
    required this.name,
    required this.unit,
    required this.experience,
    this.profileImagePath,
  });
}
