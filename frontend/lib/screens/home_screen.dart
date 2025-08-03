import 'package:flutter/material.dart';
import 'package:healthhabit/services/auth_service.dart';
import 'package:healthhabit/services/health_service.dart';
import 'package:healthhabit/widgets/activity_card.dart';
import 'package:healthhabit/widgets/badge_card.dart';
import 'package:healthhabit/widgets/challenge_card.dart';
import 'package:healthhabit/widgets/progress_chart.dart';
import 'package:healthhabit/widgets/water_intake_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HealthService _healthService = HealthService();
  final AuthService _authService = AuthService();
  
  Map<String, dynamic> _userData = {};
  List<dynamic> _activities = [];
  List<dynamic> _badges = [];
  List<dynamic> _challenges = [];
  int _waterIntake = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userData = await _healthService.getUserData();
      final activities = await _healthService.getRecentActivities();
      final badges = await _healthService.getUserBadges();
      final challenges = await _healthService.getActiveChallenges();
      final water = await _healthService.getTodayWaterIntake();

      setState(() {
        _userData = userData;
        _activities = activities;
        _badges = badges;
        _challenges = challenges;
        _waterIntake = water;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Habit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
                  _buildProfileSection(),
                  const SizedBox(height: 20),

                  // Daily Progress Section
                  _buildDailyProgressSection(),
                  const SizedBox(height: 20),

                  // Water Intake Section
                  _buildWaterIntakeSection(),
                  const SizedBox(height: 20),

                  // Activities Section
                  _buildActivitiesSection(),
                  const SizedBox(height: 20),

                  // Challenges Section
                  _buildChallengesSection(),
                  const SizedBox(height: 20),

                  // Badges Section
                  _buildBadgesSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal[100],
              child: Text(
                _userData['name']?.substring(0, 1) ?? 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData['name'] ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Level ${_userData['level'] ?? 1}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal[700],
                  ),
                ),
                Text(
                  '${_userData['points'] ?? 0} points',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to profile edit screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyProgressSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ProgressChart(
              steps: _userData['todaySteps'] ?? 0,
              stepGoal: _userData['stepGoal'] ?? 10000,
              exercise: _userData['todayExercise'] ?? 0,
              exerciseGoal: _userData['exerciseGoal'] ?? 30,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressButton(
                  icon: Icons.directions_walk,
                  label: 'Log Steps',
                  onPressed: () => _logActivity('steps'),
                ),
                _buildProgressButton(
                  icon: Icons.fitness_center,
                  label: 'Log Exercise',
                  onPressed: () => _logActivity('exercise'),
                ),
                _buildProgressButton(
                  icon: Icons.restaurant,
                  label: 'Log Meal',
                  onPressed: () => _logActivity('meal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.teal,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildWaterIntakeSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Water Intake',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            WaterIntakeWidget(
              currentIntake: _waterIntake,
              goal: _userData['waterGoal'] ?? 2000,
              onAdd: (amount) => _addWaterIntake(amount),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _activities.length,
            itemBuilder: (context, index) {
              return ActivityCard(activity: _activities[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Active Challenges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _challenges.length,
            itemBuilder: (context, index) {
              return ChallengeCard(
                challenge: _challenges[index],
                onJoin: () => _joinChallenge(_challenges[index]['id']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Your Badges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
          ),
          itemCount: _badges.length,
          itemBuilder: (context, index) {
            return BadgeCard(badge: _badges[index]);
          },
        ),
      ],
    );
  }

  Future<void> _logActivity(String type) async {
    // Implement activity logging logic
    // This would show a dialog to enter details
    // Then call _healthService.logActivity()
    // Then refresh data with _loadData()
  }

  Future<void> _addWaterIntake(int amount) async {
    try {
      await _healthService.logWaterIntake(amount);
      setState(() => _waterIntake += amount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging water: $e')),
      );
    }
  }

  Future<void> _joinChallenge(String challengeId) async {
    try {
      await _healthService.joinChallenge(challengeId);
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Challenge joined successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining challenge: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}