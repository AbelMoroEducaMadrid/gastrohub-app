import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/exceptions/api_error_handler.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';

class ProductService {
  final String baseUrl;

  ProductService({required this.baseUrl});

  Future<List<Product>> getAllProducts(String token) async {
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<Product> createProduct(String token, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<Product> updateProduct(
      String token, int id, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/products/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }
}
