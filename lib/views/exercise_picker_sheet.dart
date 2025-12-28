import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/exercise.dart';

class ExercisePickerSheet {
  static void show(BuildContext context, Function(Exercise) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final box = Hive.box<Exercise>('exercises');
          final exercises = box.values.toList();
          
          return Column(
            children: [
               Padding(
                 padding: const EdgeInsets.all(20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text('Select Exercise', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                     Row(
                       children: [
                         TextButton.icon(
                           onPressed: () {
                             Navigator.pop(context); // Close picker
                             _showCreateExerciseDialog(context, onSelect); // Open create dialog
                           },
                           icon: const Icon(Icons.add, size: 18, color: Color(0xFFBEF264)),
                           label: const Text('NEW', style: TextStyle(color: Color(0xFFBEF264), fontWeight: FontWeight.bold)),
                         ),
                         IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
                       ],
                     )
                   ],
                 ),
               ),
               Expanded(
                 child: ListView.separated(
                    controller: scrollController,
                    itemCount: exercises.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF1E293B)),
                    itemBuilder: (context, index) {
                      final ex = exercises[index];
                      return ListTile(
                        title: Text(ex.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('${ex.muscle} • ${ex.equipment}', style: const TextStyle(color: Color(0xFF94A3B8))),
                        onTap: () {
                          onSelect(ex);
                          Navigator.pop(context);
                        },
                      );
                    },
                 ),
               ),
            ],
          );
        },
      ),
    );
  }

  static void _showCreateExerciseDialog(BuildContext context, Function(Exercise) onSelect) {
    final nameController = TextEditingController();
    final muscleController = TextEditingController();
    final equipmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('New Exercise', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField('Name', nameController),
            const SizedBox(height: 12),
            _buildDialogTextField('Muscle (e.g. Chest)', muscleController),
            const SizedBox(height: 12),
            _buildDialogTextField('Equipment (e.g. Barbell)', equipmentController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final newExercise = Exercise(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  muscle: muscleController.text,
                  equipment: equipmentController.text,
                  defaultRuleId: 'double_progression', // default
                );
                
                final box = Hive.box<Exercise>('exercises');
                await box.put(newExercise.id, newExercise);
                
                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  // Auto-select is a bit tricky if we want to show the list again with the new item, 
                  // but typically "New" implies "Create and Use".
                  onSelect(newExercise); 
                }
              }
            },
            child: const Text('Create', style: TextStyle(color: Color(0xFFBEF264))),
          ),
        ],
      ),
    );
  }

  static Widget _buildDialogTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFBEF264))),
      ),
    );
  }
}
