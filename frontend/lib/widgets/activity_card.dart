import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (activity['type']) {
      case 'steps':
        icon = Icons.directions_walk;
        color = Colors.blue;
        break;
      case 'water':
        icon = Icons.water_drop;
        color = Colors.lightBlue;
        break;
      case 'exercise':
        icon = Icons.fitness_center;
        color = Colors.green;
        break;
      case 'meal':
        icon = Icons.restaurant;
        color = Colors.orange;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              _formatType(activity['type']),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${activity['value']} ${_getUnit(activity['type'])}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(activity['date']),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatType(String type) {
    switch (type) {
      case 'steps':
        return 'Steps';
      case 'water':
        return 'Water';
      case 'exercise':
        return 'Exercise';
      case 'meal':
        return 'Meal';
      default:
        return 'Activity';
    }
  }

  String _getUnit(String type) {
    switch (type) {
      case 'steps':
        return 'steps';
      case 'water':
        return 'ml';
      case 'exercise':
        return 'mins';
      case 'meal':
        return 'cal';
      default:
        return '';
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return 'Today ${_formatTime(date)}';
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month} ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}