import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onJoin;

  const ChallengeCard({
    Key? key,
    required this.challenge,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = challenge['progress'] ?? 0.0;
    final target = challenge['target'] ?? 1.0;
    final percentage = (progress / target).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge['name'] ?? 'Challenge',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              challenge['description'] ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: Colors.teal,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '${challenge['rewardPoints'] ?? 0} pts',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: challenge['joined'] == true ? null : onJoin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: challenge['joined'] == true
                      ? Colors.grey[300]
                      : Colors.teal,
                ),
                child: Text(
                  challenge['joined'] == true ? 'Joined' : 'Join Challenge',
                  style: TextStyle(
                    fontSize: 14,
                    color: challenge['joined'] == true
                        ? Colors.grey[600]
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}