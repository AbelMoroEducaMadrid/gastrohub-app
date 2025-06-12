import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/services/restaurant_service.dart';

final restaurantServiceProvider = Provider<RestaurantService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return RestaurantService(baseUrl: baseUrl);
});
