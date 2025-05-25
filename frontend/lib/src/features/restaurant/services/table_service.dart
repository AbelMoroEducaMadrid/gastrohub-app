import 'dart:convert';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/models/table.dart';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/exceptions/api_error_handler.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';

class TableService {
  final String baseUrl;

  TableService({required this.baseUrl});

  Future<List<RestaurantTable>> getAllTablesByLayout(
      String token, int layoutId) async {
    final url = Uri.parse('$baseUrl/api/tables/layout/$layoutId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    AppLogger.debug(
        'GET /api/tables/layout/$layoutId - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => RestaurantTable.fromJson(json)).toList();
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }

  Future<RestaurantTable> createTable(String token, int layoutId, int number,
      int capacity, String state) async {
    final url = Uri.parse('$baseUrl/api/tables');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'layoutId': layoutId,
        'number': number,
        'capacity': capacity,
        'state': state,
      }),
    );
    AppLogger.debug('POST /api/tables - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return RestaurantTable.fromJson(data);
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }
}
