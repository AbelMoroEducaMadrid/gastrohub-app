import 'dart:convert';

import 'package:http/http.dart' as http;

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
      return response.body; // Token en texto plano
    } else if (response.statusCode == 401) {
      throw Exception('Credenciales incorrectas');
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }
}
