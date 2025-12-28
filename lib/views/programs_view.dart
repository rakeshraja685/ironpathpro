import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/program.dart';
import '../models/enums.dart';
import 'programs_view_model.dart';
import 'active_session_view_model.dart';

class ProgramsView extends ConsumerWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programsViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Programs', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: programs.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              itemCount: programs.length + 1, // +1 for the "Create Custom" card
              itemBuilder: (context, index) {
                if (index == programs.length) {
                  return _buildCreateCustomCard(context);
                }
                return _buildProgramCard(context, programs[index], ref);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/programs/new');
        },
        backgroundColor: const Color(0xFFBEF264),
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add),
        label: const Text('New Program'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            'No Programs Found',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),
          const SizedBox(height: 24),
          _buildCreateCustomCard(context),
        ],
      ),
    );
  }

  Widget _buildCreateCustomCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Want something specific?',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.go('/programs/new');
            },
            child: const Text(
              '+ CREATE CUSTOM ROUTINE',
              style: TextStyle(
                color: Color(0xFFBEF264),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context, Program program, WidgetRef ref) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.layers, color: Color(0xFFBEF264), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        program.name,
                        style: const TextStyle(
                          color: Color(0xFFBEF264),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                           context.go('/programs/new', extra: program);
                        },
                        icon: const Icon(Icons.edit, size: 18, color: Color(0xFF94A3B8)),
                      ),
                      if (program.split == SplitType.custom)
                        IconButton(
                          onPressed: () {
                             ref.read(programsViewModelProvider.notifier).deleteProgram(program.id);
                          },
                          icon: const Icon(Icons.delete, size: 18, color: Color(0xFF94A3B8)), // hover danger?
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Days List
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: program.days.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, dayIndex) {
                  final day = program.days[dayIndex];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B), // surface
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${day.exercises.length} Exercises',
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Start Session
                             ref.read(activeSessionViewModelProvider.notifier).startSession(program, day);
                             context.go('/session');
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF334155),
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
