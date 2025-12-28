import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../models/history_entry.dart';
import '../models/workout_session.dart';


part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<void> build() async {
    return;
  }
}

@riverpod
Box<UserProfile> userProfileBox(Ref ref) {
  return Hive.box<UserProfile>('user_profile');
}

@riverpod
Box<HistoryEntry> historyBox(Ref ref) {
  return Hive.box<HistoryEntry>('history');
}

@riverpod
Box<WorkoutSession> activeSessionBox(Ref ref) {
  return Hive.box<WorkoutSession>('active_session');
}

@riverpod
UserProfile? userProfile(Ref ref) {
  final box = ref.watch(userProfileBoxProvider);
  if (box.isEmpty) return null;
  return box.getAt(0);
}

@riverpod
List<HistoryEntry> recentHistory(Ref ref) {
  final box = ref.watch(historyBoxProvider);
  final list = box.values.toList();
  list.sort((a, b) => b.date.compareTo(a.date)); // Newest first
  return list;
}

@riverpod
WorkoutSession? activeSession(Ref ref) {
  final box = ref.watch(activeSessionBoxProvider);
  if (box.isEmpty) return null;
  return box.getAt(0);
}

@riverpod
int workoutsThisWeek(Ref ref) {
  final history = ref.watch(recentHistoryProvider);
  final now = DateTime.now();
  final sevenDaysAgo = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
  
  return history.where((h) => h.date > sevenDaysAgo).length;
}

@riverpod
double lastSessionVolume(Ref ref) {
  final history = ref.watch(recentHistoryProvider);
  if (history.isEmpty) return 0;
  return history.first.totalVolume;
}
