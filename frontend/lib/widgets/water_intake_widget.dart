import 'package:flutter/material.dart';

class WaterIntakeWidget extends StatelessWidget {
  final int currentIntake;
  final int goal;
  final Function(int) onAdd;

  const WaterIntakeWidget({
    Key? key,
    required this.currentIntake,
    required this.goal,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (currentIntake / goal).clamp(0.0, 1.0);
    
    return Column(
      children: [
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentIntake/$goal ml',
              style: const TextStyle(fontSize: 14),
            ),
            Row(
              children: [
                _buildWaterButton(250, '+250ml'),
                const SizedBox(width: 8),
                _buildWaterButton(500, '+500ml'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaterButton(int amount, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => onAdd(amount),
      child: Text(label),
    );
  }
}