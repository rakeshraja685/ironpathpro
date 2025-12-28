import '../models/exercise.dart';
import '../models/program.dart';
import '../models/program_day.dart';
import '../models/program_day_exercise.dart';
import '../models/enums.dart';

class DefaultData {
  static final List<Exercise> exercises = [
    Exercise(id: 'bench_press', name: 'Barbell Bench Press', muscle: 'Chest', equipment: 'Barbell', defaultRuleId: 'double_progression'),
    Exercise(id: 'squat', name: 'Barbell Squat', muscle: 'Legs', equipment: 'Barbell', defaultRuleId: 'double_progression'),
    Exercise(id: 'deadlift', name: 'Deadlift', muscle: 'Back', equipment: 'Barbell', defaultRuleId: 'double_progression'),
    Exercise(id: 'overhead_press', name: 'Overhead Press', muscle: 'Shoulders', equipment: 'Barbell', defaultRuleId: 'double_progression'),
    Exercise(id: 'pull_up', name: 'Pull Up', muscle: 'Back', equipment: 'Bodyweight', defaultRuleId: 'double_progression'),
    Exercise(id: 'dumbbell_row', name: 'Dumbbell Row', muscle: 'Back', equipment: 'Dumbbell', defaultRuleId: 'double_progression'),
    Exercise(id: 'dumbbell_curl', name: 'Dumbbell Curl', muscle: 'Biceps', equipment: 'Dumbbell', defaultRuleId: 'double_progression'),
    Exercise(id: 'tricep_extension', name: 'Tricep Extension', muscle: 'Triceps', equipment: 'Cable', defaultRuleId: 'double_progression'),
    Exercise(id: 'leg_press', name: 'Leg Press', muscle: 'Legs', equipment: 'Machine', defaultRuleId: 'double_progression'),
    Exercise(id: 'lunge', name: 'Walking Lunge', muscle: 'Legs', equipment: 'Dumbbell', defaultRuleId: 'double_progression'),
  ];

  static final Program pplProgram = Program(
    id: 'ppl_default',
    name: 'Push Pull Legs',
    split: SplitType.ppl,
    days: [
      ProgramDay(
        id: 'push_1',
        name: 'Push A',
        exercises: [
          ProgramDayExercise(exerciseId: 'bench_press', targetSets: 3, targetReps: '8-12'),
          ProgramDayExercise(exerciseId: 'overhead_press', targetSets: 3, targetReps: '8-12'),
          ProgramDayExercise(exerciseId: 'tricep_extension', targetSets: 3, targetReps: '12-15'),
        ],
      ),
      ProgramDay(
        id: 'pull_1',
        name: 'Pull A',
        exercises: [
          ProgramDayExercise(exerciseId: 'deadlift', targetSets: 3, targetReps: '5'),
          ProgramDayExercise(exerciseId: 'pull_up', targetSets: 3, targetReps: 'AMRAP'),
          ProgramDayExercise(exerciseId: 'dumbbell_row', targetSets: 3, targetReps: '10-12'),
          ProgramDayExercise(exerciseId: 'dumbbell_curl', targetSets: 3, targetReps: '12-15'),
        ],
      ),
      ProgramDay(
        id: 'legs_1',
        name: 'Legs A',
        exercises: [
          ProgramDayExercise(exerciseId: 'squat', targetSets: 3, targetReps: '5-8'),
          ProgramDayExercise(exerciseId: 'leg_press', targetSets: 3, targetReps: '10-15'),
          ProgramDayExercise(exerciseId: 'lunge', targetSets: 3, targetReps: '12-15'),
        ],
      ),
    ],
  );
}
