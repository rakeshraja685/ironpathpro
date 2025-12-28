import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/exercise.dart';
import 'exercise_details_view_model.dart';

class ExerciseDetailsView extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseDetailsView({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(exerciseDetailsViewModelProvider(exercise.name));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Info Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTag(exercise.muscle, const Color(0xFFBEF264)),
                      const SizedBox(width: 8),
                      _buildTag(exercise.equipment, const Color(0xFF94A3B8)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    'Perform this exercise with controlled tempo. Focus on the ${exercise.muscle.toLowerCase()}.',
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Stats / History
            historyAsync.when(
              data: (history) {
                 if (history.isEmpty) {
                   return const Center(
                     child: Padding(
                       padding: EdgeInsets.all(32.0),
                       child: Text('No history yet.', style: TextStyle(color: Colors.grey)),
                     ),
                   );
                 }

                 // Calculate Stats
                 final maxWeight = history.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
                 final max1RM = history.map((e) => e.oneRepMax).reduce((a, b) => a > b ? a : b);
                 final totalSessions = history.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Personal Best', '${maxWeight}kg')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard('Calc. 1RM', '${max1RM.round()}kg')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard('Sessions Logged', '$totalSessions'),
                    
                    const SizedBox(height: 32),
                    const Text(
                      'Progress',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    // Constrained height for the chart
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                             leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: history.asMap().entries.map((e) {
                                  // Reverse index for X axis (oldest to newest)
                                  final index = history.length - 1 - e.key;
                                  return FlSpot(index.toDouble(), e.value.oneRepMax);
                              }).toList(),
                              isCurved: true,
                              color: const Color(0xFFBEF264),
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),

                     const SizedBox(height: 32),
                     const Text(
                       'History',
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                     ),
                     const SizedBox(height: 16),
                     ...history.map((h) => _buildHistoryItem(h)),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ExerciseHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(
             DateFormat.yMMMd().format(item.date), 
             style: const TextStyle(color: Colors.white),
           ),
           Text(
             item.bestSetStr,
             style: const TextStyle(color: Color(0xFFBEF264), fontWeight: FontWeight.bold, fontFamily: 'monospace'),
           ),
        ],
      ),
    );
  }
}
