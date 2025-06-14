import 'dart:convert';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/models/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/exceptions/api_error_handler.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';

class RestaurantRegistration {
  final String name;
  final String address;
  final String cuisineType;
  final String description;
  final int paymentPlanId;

  RestaurantRegistration({
    required this.name,
    required this.address,
    required this.cuisineType,
    required this.description,
    required this.paymentPlanId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'cuisineType': cuisineType,
      'description': description,
      'paymentPlanId': paymentPlanId,
    };
  }
}

class RestaurantService {
  final String baseUrl;

  RestaurantService({required this.baseUrl});

  Future<Restaurant> registerRestaurant(
      String token, RestaurantRegistration restaurant) async {
    final url = Uri.parse('$baseUrl/api/restaurants');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(restaurant.toJson()),
    );
    AppLogger.debug('POST /api/restaurants - Status: ${response.statusCode}');
    AppLogger.debug('Response body: ${response.body}');
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Restaurant.fromJson(data);
    } else {
      final error = ApiErrorHandler.handleErrorResponse(response);
      throw ApiException(error['title']!, error['message']!);
    }
  }
}
