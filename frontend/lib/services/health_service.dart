import 'package:healthhabit/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthService {

  Future<Map<String, dynamic>> getUserData() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/user'));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getRecentActivities() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/activities/recent'));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getUserBadges() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/badges'));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getActiveChallenges() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/challenges/active'));
    return jsonDecode(response.body);
  }

  Future<int> getTodayWaterIntake() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/water/today'));
    return jsonDecode(response.body)['amount'];
  }

  Future<void> logWaterIntake(int amount) async {
    await http.post(
      Uri.parse('${Constants.apiUrl}/water'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );
  }

  Future<void> joinChallenge(String challengeId) async {
    await http.post(
      Uri.parse('${Constants.apiUrl}/challenges/$challengeId/join'),
    );
  }

  Future<void> logActivity(String type, int value) async {
    await http.post(
      Uri.parse('${Constants.apiUrl}/activities'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'type': type, 'value': value}),
    );
  }
}