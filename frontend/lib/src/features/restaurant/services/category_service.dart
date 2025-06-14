import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/exceptions/api_error_handler.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';
import 'package:gastrohub_app/src/features/restaurant/models/category.dart';

class CategoryService {
  final String baseUrl;

  CategoryService({required this.baseUrl});

  Future<List<Category>> getAllCategories(String token) async {
    final url = Uri.parse('$baseUrl/api/categories');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }
}
