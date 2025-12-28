import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'exercise_picker_sheet.dart';


import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_set.dart';
import '../models/session_exercise.dart';
import '../models/exercise.dart';
import 'active_session_view_model.dart';

import '../utils/string_formatting.dart';

class ActiveSessionView extends ConsumerWidget {
  const ActiveSessionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionViewModelProvider);
    final duration = ref.watch(sessionTimerProvider);

    if (session == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(title: const Text('No Active Workout'), backgroundColor: Colors.transparent),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No active workout found.', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/programs'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBEF264), foregroundColor: Colors.black),
                child: const Text('Start New Workout'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active Session', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(
              _formatTime(duration),
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Color(0xFFBEF264)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        actions: [
          IconButton(
            onPressed: () {
               // Confirm cancel
               showDialog(
                 context: context, 
                 builder: (c) => AlertDialog(
                   title: const Text('Discard Workout?'),
                   content: const Text('Progress will be lost.'),
                   actions: [
                     TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                     TextButton(
                       onPressed: () {
                         Navigator.pop(c);
                         ref.read(activeSessionViewModelProvider.notifier).cancelSession();
                         context.go('/');
                       }, 
                       style: TextButton.styleFrom(foregroundColor: Colors.red),
                       child: const Text('Discard')
                     ),
                   ],
                 )
               );
            },
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                 await ref.read(activeSessionViewModelProvider.notifier).finishSession();
                 if (context.mounted) context.go('/');
              },
              icon: const Icon(Icons.save, size: 16),
              label: const Text('Finish'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBEF264),
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: session.exercises.length + 1, // +1 for Add Exercise (placeholder)
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == session.exercises.length) {
            return _buildAddExerciseButton(context, ref);
          }
          
          final exercise = session.exercises[index];
          // We need exercise name, but we don't have it directly here properly mapped without a specialized ViewModel getter or passing it down
          // For MVP we just use ID or fetch it via another provider.
          // Ideally ActiveSessionViewModel exposes a mapped object.
          // We can use a FutureBuilder or a separate widget that fetches name.
          return _ExerciseCard(
            exerciseIndex: index,
            exercise: exercise,
            sessionViewModel: ref.read(activeSessionViewModelProvider.notifier),
          );
        },
      ),
    );
  }

  Widget _buildAddExerciseButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
           ExercisePickerSheet.show(context, (selected) {
             ref.read(activeSessionViewModelProvider.notifier).addExercise(selected.id);
           });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Exercise'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          foregroundColor: const Color(0xFF94A3B8),
          side: const BorderSide(color: Color(0xFF334155), style: BorderStyle.solid), 
        ),
      ),
    );
  }

  String _formatTime(int sec) {
    final m = (sec / 60).floor();
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ExerciseCard extends ConsumerWidget {
  final int exerciseIndex;
  final SessionExercise exercise;
  final ActiveSessionViewModel sessionViewModel;

  const _ExerciseCard({
    required this.exerciseIndex,
    required this.exercise,
    required this.sessionViewModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Basic ExpansionTile approach
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: const Color(0xFF334155).withOpacity(0.5))),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: InkWell(
          onTap: () {
            final box = Hive.box<Exercise>('exercises');
            final exerciseObj = box.get(exercise.exerciseId);
            if (exerciseObj != null) {
              context.push('/exercise', extra: exerciseObj);
            } else {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exercise details not found')));
            }
          },
          child: Row(
            children: [
              Text(
                formatExerciseName(exercise.exerciseId), 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.info_outline, size: 16, color: Colors.grey),
            ],
          ),
        ),
        subtitle: Text(
          '${exercise.sets.where((s) => s.completed).length}/${exercise.sets.length} sets',
          style: const TextStyle(color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSetHeader(),
                ...exercise.sets.asMap().entries.map((entry) {
                   final setIdx = entry.key;
                   final set = entry.value;
                   return _SetRow(
                     set: set, 
                     index: setIdx,
                     onUpdate: (field, val) => sessionViewModel.updateSet(exerciseIndex, setIdx, weight: field == 'weight' ? val as double : null, reps: field == 'reps' ? val as int : null),
                     onToggle: () => sessionViewModel.updateSet(exerciseIndex, setIdx, completed: !set.completed),
                   );
                }),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => sessionViewModel.addSet(exerciseIndex),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Set'),
                        style: TextButton.styleFrom(backgroundColor: const Color(0xFF334155), foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: const [
          SizedBox(width: 30, child: Text('#', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10))),
          Expanded(child: Text('Weight (kg)', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10))),
          Expanded(child: Text('Reps', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10))),
          SizedBox(width: 40, child: Text('Done', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10))),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final WorkoutSet set;
  final int index;
  final Function(String, dynamic) onUpdate;
  final VoidCallback onToggle;

  const _SetRow({required this.set, required this.index, required this.onUpdate, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final completedColor = const Color(0xFFBEF264).withOpacity(0.1);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: set.completed ? completedColor : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: set.completed ? const Color(0xFFBEF264).withOpacity(0.3) : Colors.transparent),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30, 
            child: Text('${index + 1}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: set.completed ? const Color(0xFFBEF264) : Colors.white))
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 _Stepper(value: set.weight, step: 2.5, onChange: (v) => onUpdate('weight', v), disabled: set.completed),
              ],
            ),
          ),
          Expanded(
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 _Stepper(value: set.reps.toDouble(), step: 1, onChange: (v) => onUpdate('reps', v.toInt()), disabled: set.completed),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: InkWell(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: set.completed ? const Color(0xFFBEF264) : const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: set.completed ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final double value;
  final double step;
  final Function(double) onChange;
  final bool disabled;

  const _Stepper({required this.value, required this.step, required this.onChange, required this.disabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF334155),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: disabled ? null : () => onChange((value - step).clamp(0, 999)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Icon(Icons.remove, size: 14, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value % 1 == 0 ? value.toInt().toString() : value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
             onTap: disabled ? null : () => onChange(value + step),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Icon(Icons.add, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
