import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_session.dart';
import '../models/program.dart';
import '../models/program_day.dart';
import '../models/session_exercise.dart';
import '../models/workout_set.dart';
import '../models/history_entry.dart';
import '../models/history_entry_exercise.dart';
import '../models/exercise.dart';
import '../services/notification_service.dart';

part 'active_session_view_model.g.dart';

@riverpod
class ActiveSessionViewModel extends _$ActiveSessionViewModel {
  Timer? _timer;
  Timer? _saveTimer;

  @override
  WorkoutSession? build() {
    // Load initial state from Hive
    final box = Hive.box<WorkoutSession>('active_session');
    if (box.isNotEmpty) {
      _startTimer();
      return box.getAt(0);
    }
    return null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final session = state;
      if (session != null) {
        session.durationSec++;
        state = session; // Force rebuild to show timer
        
        // Auto-save every 10 seconds if modified
        if (session.durationSec % 10 == 0) {
           _scheduleSave();
        }
      }
    });
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 1000), () async {
       final session = state;
       if (session != null && session.isInBox) {
         await session.save();
       }
    });
  }

  Future<void> startSession(Program program, ProgramDay day) async {
    final box = Hive.box<WorkoutSession>('active_session');
    await box.clear();

    final sessionExercises = day.exercises.map((e) {
      // Create initial sets
      final sets = List.generate(e.targetSets, (index) {
        return WorkoutSet(
          id: const Uuid().v4(),
          setNumber: index + 1,
          weight: 0,
          reps: 0,
          rpe: 8,
          completed: false,
          isWarmup: false,
        );
      });

      return SessionExercise(
        exerciseId: e.exerciseId,
        progressionRuleId: e.progressionRuleId,
        sets: sets,
        notes: '',
      );
    }).toList();

    final newSession = WorkoutSession(
      id: const Uuid().v4(),
      programDayId: day.id,
      date: DateTime.now().millisecondsSinceEpoch,
      durationSec: 0,
      exercises: sessionExercises,
      completed: false,
    );

    await box.add(newSession);
    state = newSession;
    _startTimer();
  }

  Future<void> updateSet(int exerciseIndex, int setIndex, {double? weight, int? reps, bool? completed}) async {
    final session = state;
    if (session == null) return;

    final ex = session.exercises[exerciseIndex];
    final set = ex.sets[setIndex];

    if (weight != null) set.weight = weight;
    if (reps != null) set.reps = reps;
    if (completed != null) set.completed = completed;
    
    // Schedule save instead of awaiting immediately
    _scheduleSave();
    
    // Trigger Rest Timer Notification if set is completed
    if (completed == true) {
      final notifService = ref.read(notificationServiceProvider);
      // Default rest time 90s for now
      await notifService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Rest Finished',
        body: 'Time to crush the next set!',
        delay: const Duration(seconds: 90),
      );
    }
    
    // Force rebuild
    ref.notifyListeners(); // This is crucial for UI update since we mutated the object
  }

  Future<void> addSet(int exerciseIndex) async {
    final session = state;
    if (session == null) return;

    final ex = session.exercises[exerciseIndex];
    final lastSet = ex.sets.isNotEmpty ? ex.sets.last : null;
    
    final newSet = WorkoutSet(
      id: const Uuid().v4(),
      setNumber: ex.sets.length + 1,
      weight: lastSet?.weight ?? 0,
      reps: lastSet?.reps ?? 0,
      rpe: 8,
      completed: false,
      isWarmup: false,
    );
    
    ex.sets.add(newSet);
    _scheduleSave();
    ref.notifyListeners();
  }

  Future<void> addExercise(String exerciseId) async {
    final session = state;
    if (session == null) return;
    
    // Create new session exercise with 3 empty sets (default)
    final sets = List.generate(3, (index) {
       return WorkoutSet(
          id: const Uuid().v4(),
          setNumber: index + 1,
          weight: 0,
          reps: 0,
          rpe: 8,
          completed: false,
          isWarmup: false,
        );
    });
    
    final newSessionExercise = SessionExercise(
      exerciseId: exerciseId,
      progressionRuleId: 'double_progression', // default or fetch from exercise
      sets: sets,
      notes: '',
    );
    
    session.exercises.add(newSessionExercise);
    _scheduleSave();
    ref.notifyListeners();
  }

  Future<void> removeSet(int exerciseIndex, int setIndex) async {
     final session = state;
    if (session == null) return;
    
    session.exercises[exerciseIndex].sets.removeAt(setIndex);
    _scheduleSave();
    ref.notifyListeners();
  }

  Future<void> finishSession() async {
    final session = state;
    if (session == null) return;

    _timer?.cancel();
    _saveTimer?.cancel();
    session.completed = true;
    await session.save(); // Ensure final state is saved
    
    // Calculate total volume
    double volume = 0;
    List<HistoryEntryExercise> historyExercises = [];

    for (var ex in session.exercises) {
      String bestSet = "-";
      double maxWeight = -1;
      
      final exerciseName = _getExerciseName(ex.exerciseId);

      for (var set in ex.sets) {
        if (set.completed) {
          volume += set.weight * set.reps;
          if (set.weight > maxWeight) {
            maxWeight = set.weight;
            bestSet = "${set.weight}kg x ${set.reps}";
          }
        }
      }
      historyExercises.add(HistoryEntryExercise(name: exerciseName, bestSet: bestSet));
    }

    // Save to History
    final historyBox = Hive.box<HistoryEntry>('history');
    final entry = HistoryEntry(
      sessionId: session.id,
      date: session.date, // Keep original start time? or Now? React uses start time usually.
      programName: _getProgramName(session.programDayId) ?? "Unknown Program", // We need logic to map back 
      dayName: "Workout", // We lost the name reference in WorkoutSession, usually good to store it.
      totalVolume: volume,
      exercises: historyExercises,
    );

    await historyBox.add(entry);

    // Clear active session
    final box = Hive.box<WorkoutSession>('active_session');
    await box.clear();
    state = null;
  }

  Future<void> cancelSession() async {
    _timer?.cancel();
    _saveTimer?.cancel();
    final box = Hive.box<WorkoutSession>('active_session');
    await box.clear();
    state = null;
  }

  String _getExerciseName(String id) {
    // Helper to fetch name from exercises box
    if (!Hive.isBoxOpen('exercises')) return id;
    final box = Hive.box<Exercise>('exercises');
    final ex = box.values.firstWhere((e) => e.id == id, orElse: () => Exercise(id: id, name: 'Unknown', muscle: '', equipment: '', defaultRuleId: ''));
    return ex.name;
  }

  String? _getProgramName(String dayId) {
     if (!Hive.isBoxOpen('programs')) return null;
     final box = Hive.box<Program>('programs');
     for (var p in box.values) {
       if (p.days.any((d) => d.id == dayId)) return p.name;
     }
     return null;
  }
}

// Timer provider to separate high-frequency updates
@riverpod
class SessionTimer extends _$SessionTimer {
  @override
  int build() {
    final session = ref.watch(activeSessionViewModelProvider);
    return session?.durationSec ?? 0;
  }
}
