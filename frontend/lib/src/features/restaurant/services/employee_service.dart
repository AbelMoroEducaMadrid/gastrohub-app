import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/exceptions/api_error_handler.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';
import 'package:gastrohub_app/src/features/auth/models/user.dart';

class EmployeeService {
  final String baseUrl;

  EmployeeService({required this.baseUrl});

  Future<List<User>> getRestaurantEmployees(String token) async {
    final url = Uri.parse('$baseUrl/api/users/my-restaurant-users');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<void> updateEmployeeRole(
      String token, int userId, String roleName) async {
    final url =
        Uri.parse('$baseUrl/api/users/my-restaurant-users/$userId/role');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'roleName': roleName}),
    );

    if (response.statusCode != 200) {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<void> kickEmployee(String token, int userId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/kick');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }
}
