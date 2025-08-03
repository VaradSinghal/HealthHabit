// import 'dart:convert';
// import 'package:healthhabit/constants/apiendpoints.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ApiService {
//   static const String _authTokenKey = 'auth_token';

//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_authTokenKey);
//   }

//   static Future<Map<String, dynamic>> fetchGoals() async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse(ApiEndpoints.goals),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load goals: ${response.body}');
//     }
//   }

//   static Future<List<dynamic>> fetchBadges() async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse(ApiEndpoints.badges),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load badges: ${response.body}');
//     }
//   }

//   static Future<void> updateGoal({
//     int? steps,
//     int? water,
//     int? activeBreaks,
//     int? nutritiousMeals,
//   }) async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse(ApiEndpoints.goals),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         if (steps != null) 'steps': steps,
//         if (water != null) 'water': water,
//         if (activeBreaks != null) 'activeBreaks': activeBreaks,
//         if (nutritiousMeals != null) 'nutritiousMeals': nutritiousMeals,
//       }),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to update goal: ${response.body}');
//     }
//   }

//   static Future<void> awardBadge(String name, {String? description}) async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse(ApiEndpoints.awardBadge),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'name': name, if (description != null) 'description': description}),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to award badge: ${response.body}');
//     }
//   }
// }