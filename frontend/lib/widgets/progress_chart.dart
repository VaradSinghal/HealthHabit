import 'package:flutter/material.dart';

class ProgressChart extends StatelessWidget {
  final int steps;
  final int stepGoal;
  final int exercise;
  final int exerciseGoal;

  const ProgressChart({
    Key? key,
    required this.steps,
    required this.stepGoal,
    required this.exercise,
    required this.exerciseGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildProgressBar(
            'Steps',
            steps.toDouble(),
            stepGoal.toDouble(),
            Colors.blue,
            Icons.directions_walk,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildProgressBar(
            'Exercise',
            exercise.toDouble(),
            exerciseGoal.toDouble(),
            Colors.green,
            Icons.fitness_center,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    String label,
    double value,
    double goal,
    Color color,
    IconData icon,
  ) {
    final percentage = (value / goal).clamp(0.0, 1.0);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 20, color: color),
            Text(
              '$value/${goal.toInt()}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}