import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gastrohub_app/src/features/restaurant/models/payment_plan.dart';

class PaymentPlanService {
  final String baseUrl;

  PaymentPlanService({required this.baseUrl});

  Future<List<PaymentPlan>> getPaymentPlans(String token) async {
    final url = Uri.parse('$baseUrl/api/payment-plans');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PaymentPlan.fromJson(json)).toList();
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
