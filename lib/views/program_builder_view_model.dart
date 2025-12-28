import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/program.dart';
import '../models/program_day.dart';
import '../models/program_day_exercise.dart';
import '../models/exercise.dart';
import '../models/enums.dart';

part 'program_builder_view_model.g.dart';

class ProgramBuilderState {
  final String? id; // Null for new, set for edit
  final String name;
  final List<ProgramBuilderDay> days;
  final bool isSubmitting;

  ProgramBuilderState({
    this.id,
    this.name = '',
    this.days = const [],
    this.isSubmitting = false,
  });

  ProgramBuilderState copyWith({
    String? id,
    String? name,
    List<ProgramBuilderDay>? days,
    bool? isSubmitting,
  }) {
    return ProgramBuilderState(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ProgramBuilderDay {
  final String id;
  final String name;
  final List<ProgramDayExercise> exercises;

  ProgramBuilderDay({
    required this.id,
    required this.name,
    required this.exercises,
  });
  
  ProgramBuilderDay copyWith({
    String? name,
    List<ProgramDayExercise>? exercises,
  }) {
    return ProgramBuilderDay(
      id: id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }
}

@riverpod
class ProgramBuilderViewModel extends _$ProgramBuilderViewModel {
  @override
  ProgramBuilderState build() {
    return ProgramBuilderState(days: [
      ProgramBuilderDay(id: const Uuid().v4(), name: 'Day 1', exercises: [])
    ]);
  }

  void loadProgram(Program program) {
    // map Hive models to Builder models
    final builderDays = program.days.map((d) {
      return ProgramBuilderDay(
        id: d.id,
        name: d.name,
        // Clone exercises list so we don't mutate Hive object directly until save
        exercises: List.from(d.exercises), 
      );
    }).toList();

    state = ProgramBuilderState(
      id: program.id,
      name: program.name,
      days: builderDays,
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void addDay() {
    final newDay = ProgramBuilderDay(
      id: const Uuid().v4(),
      name: 'Day ${state.days.length + 1}',
      exercises: [],
    );
    state = state.copyWith(days: [...state.days, newDay]);
  }

  void removeDay(String dayId) {
    state = state.copyWith(days: state.days.where((d) => d.id != dayId).toList());
  }
  
  void updateDayName(String dayId, String newName) {
     final days = state.days.map((d) {
      if (d.id == dayId) return d.copyWith(name: newName);
      return d;
    }).toList();
    state = state.copyWith(days: days);
  }

  void addExerciseToDay(String dayId, Exercise exercise) {
    final days = state.days.map((d) {
      if (d.id == dayId) {
        final newExercise = ProgramDayExercise(
          exerciseId: exercise.id,
          targetSets: 3,
          targetReps: '8-12',
        );
        return d.copyWith(exercises: [...d.exercises, newExercise]);
      }
      return d;
    }).toList();
    state = state.copyWith(days: days);
  }

  void removeExerciseFromDay(String dayId, int index) {
    final days = state.days.map((d) {
      if (d.id == dayId) {
        final exercises = [...d.exercises];
        exercises.removeAt(index);
        return d.copyWith(exercises: exercises);
      }
      return d;
    }).toList();
    state = state.copyWith(days: days);
  }

  Future<bool> saveProgram() async {
    if (state.name.isEmpty || state.days.isEmpty) return false;
    
    state = state.copyWith(isSubmitting: true);

    try {
      final programDays = state.days.map((d) {
        return ProgramDay(
          id: d.id,
          name: d.name,
          exercises: d.exercises, // These are HiveObjects, should move inside ProgramDay
        );
      }).toList();

      final program = Program(
        id: state.id ?? const Uuid().v4(), // Use existing ID if editing
        name: state.name,
        split: SplitType.custom,
        days: programDays,
      );

      final box = Hive.box<Program>('programs');
      await box.put(program.id, program);
      
      // ref.invalidate(programsViewModelProvider); // Assuming programs provider watches box or invalidates self
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
