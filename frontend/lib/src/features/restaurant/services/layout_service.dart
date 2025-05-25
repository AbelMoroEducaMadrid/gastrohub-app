import 'dart:convert';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/models/layout.dart';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/exceptions/api_error_handler.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';

class LayoutService {
  final String baseUrl;

  LayoutService({required this.baseUrl});

  Future<List<Layout>> getAllLayoutsByRestaurant(
      String token, int restaurantId) async {
    final url = Uri.parse('$baseUrl/api/layouts?restaurantId=$restaurantId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    AppLogger.debug(
        'GET /api/layouts?restaurantId=$restaurantId - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Layout.fromJson(json)).toList();
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<Layout> createLayout(
      String token, String name, int restaurantId) async {
    final url = Uri.parse('$baseUrl/api/layouts');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'restaurantId': restaurantId}),
    );
    AppLogger.debug('POST /api/layouts - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Layout.fromJson(data);
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<Layout> updateLayout(String token, int layoutId, String name) async {
    final url = Uri.parse('$baseUrl/api/layouts/$layoutId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );
    AppLogger.debug(
        'PUT /api/layouts/$layoutId - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Layout.fromJson(data);
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<void> deleteLayout(String token, int layoutId) async {
    final url = Uri.parse('$baseUrl/api/layouts/$layoutId');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    AppLogger.debug(
        'DELETE /api/layouts/$layoutId - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode != 204) {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }
}
