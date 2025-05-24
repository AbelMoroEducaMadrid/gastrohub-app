import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';

class AppConfig {
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:8080';
  static String get stripeKey =>
      dotenv.env['STRIPE_KEY'] ?? 'tu_clave_de_stripe';
  static bool get isProduction => dotenv.env['ENV'] == 'production';
  //static const int apiTimeoutSeconds = 30;


  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env.local');
      AppLogger.debug(".env.local cargado");
    } catch (_) {
      await dotenv.load(fileName: '.env');
      AppLogger.debug(".env.local no encontrado, usando .env");
    }
  }
}
