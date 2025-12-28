import 'package:flutter/material.dart';
import 'exercise_picker_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise.dart';
import '../models/program.dart';
import 'program_builder_view_model.dart';
import 'programs_view_model.dart'; // To invalidate list on save

class ProgramBuilderView extends ConsumerStatefulWidget {
  final Program? existingProgram;
  const ProgramBuilderView({super.key, this.existingProgram});

  @override
  ConsumerState<ProgramBuilderView> createState() => _ProgramBuilderViewState();
}

class _ProgramBuilderViewState extends ConsumerState<ProgramBuilderView> {
  @override
  void initState() {
    super.initState();
    if (widget.existingProgram != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(programBuilderViewModelProvider.notifier).loadProgram(widget.existingProgram!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderViewModelProvider);
    final viewModel = ref.read(programBuilderViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(widget.existingProgram != null ? 'Edit Routine' : 'New Custom Routine'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: state.isSubmitting
                ? null
                : () async {
                    if (state.name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please name your routine')),
                      );
                      return;
                    }
                    final success = await viewModel.saveProgram();
                    if (success && context.mounted) {
                      ref.invalidate(programsViewModelProvider);
                      context.pop();
                    }
                  },
            child: state.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'SAVE',
                    style: TextStyle(
                      color: Color(0xFFBEF264),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Routine Name
            TextField(
              onChanged: viewModel.updateName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Routine Name (e.g. Upper/Lower)',
                hintStyle: TextStyle(color: Color(0xFF64748B)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            const SizedBox(height: 24),

            // Days List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.days.length,
              itemBuilder: (context, index) {
                final day = state.days[index];
                return _buildDayCard(context, day, viewModel);
              },
            ),

            const SizedBox(height: 24),
            
            // Add Day Button
            Center(
              child: TextButton.icon(
                onPressed: viewModel.addDay,
                icon: const Icon(Icons.add, color: Color(0xFFBEF264)),
                label: const Text(
                  'ADD WORKOUT DAY',
                  style: TextStyle(
                    color: Color(0xFFBEF264),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(
      BuildContext context, ProgramBuilderDay day, ProgramBuilderViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: day.name)
                    ..selection = TextSelection.fromPosition(
                        TextPosition(offset: day.name.length)),
                  onChanged: (val) => viewModel.updateDayName(day.id, val),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Day Name',
                    hintStyle: TextStyle(color: Color(0xFF64748B)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => viewModel.removeDay(day.id),
                icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const Divider(color: Color(0xFF334155), height: 32),
          
          if (day.exercises.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No exercises added',
                style: TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic),
              ),
            )
          else
            ...day.exercises.asMap().entries.map((entry) {
              final idx = entry.key;
              final ex = entry.value;
              // Need to lookup exercise Name from ID using a provider or box?
              // For builder simplicity we'll just show ID or do a lookup in a real app.
              // Let's do a quick lookup helper widget or pass name in state?
              // Passing Hive object in generic VM implementation is tricky.
              // Let's resolve name via a FutureBuilder or helper since we have ID.
              return _ExerciseItem(
                exerciseId: ex.exerciseId, 
                onRemove: () => viewModel.removeExerciseFromDay(day.id, idx),
                sets: ex.targetSets,
                reps: ex.targetReps,
              );
            }),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => ExercisePickerSheet.show(context, (selected) {
                viewModel.addExerciseToDay(day.id, selected);
              }),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Exercise'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final String exerciseId;
  final VoidCallback onRemove;
  final int sets;
  final String reps;

  const _ExerciseItem({
    required this.exerciseId, 
    required this.onRemove,
    required this.sets,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Exercise>('exercises');
    final exercise = box.get(exerciseId); // Sync lookup is fine for Hive

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise?.name ?? 'Unknown Exercise',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$sets sets x $reps reps',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFEF4444), size: 20), // red-500
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
