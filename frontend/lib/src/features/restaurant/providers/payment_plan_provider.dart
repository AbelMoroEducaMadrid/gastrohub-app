// lib/src/auth/providers/auth_provider.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/services/payment_plan_service.dart';

final paymentPlanServiceProvider = Provider<PaymentPlanService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return PaymentPlanService(baseUrl: baseUrl);
});
