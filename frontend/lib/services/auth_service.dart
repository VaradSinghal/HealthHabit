import 'package:healthhabit/utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/auth/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/auth/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Registration failed');
    }
  }
}