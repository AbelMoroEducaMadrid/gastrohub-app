import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/auth/models/user.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 401) {
      throw Exception('Credenciales incorrectas');
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }

  Future<User> getUserData(String token) async {
    final url = Uri.parse('$baseUrl/api/users/me');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception(
          'Error al obtener datos del usuario: ${response.statusCode}');
    }
  }
}
