import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';
import '../models/enums.dart';
import 'home_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  void build() {}

  Future<void> clearAllData() async {
    // Clear functional data
    await Hive.box<UserProfile>('user_profile').clear();
    await Hive.box('programs').clear(); // Will trigger re-seeding on next load of ProgramsViewModel 
    await Hive.box('history').clear();
    await Hive.box('active_session').clear();
    
    // Note: Exercises box usually static-ish but we can clear it too to test re-seeding
    await Hive.box('exercises').clear();

    // Clear Auth
    final refNotifier = ref.read(authServiceProvider.notifier);
    await refNotifier.logout();
    
    // Auth state change will trigger router redirect
  }
  
  Future<void> updateName(String name) async {
    final box = Hive.box<UserProfile>('user_profile');
    if (box.isNotEmpty) {
      final profile = box.getAt(0);
      if (profile != null) {
        profile.name = name;
        await profile.save();
        ref.invalidate(userProfileProvider); // Force refresh of profile provider
      }
    } else {
        // Create if missing (rare case)
        await box.add(UserProfile(
          name: name,
          unit: Unit.kg, // default
          experience: ExperienceLevel.intermediate,
        ));
         ref.invalidate(userProfileProvider);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      final box = Hive.box<UserProfile>('user_profile');
      if (box.isNotEmpty) {
        final profile = box.getAt(0);
        if (profile != null) {
          profile.profileImagePath = savedImage.path;
          await profile.save();
          ref.invalidate(userProfileProvider);
        }
      }
    }
  }
}
