import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:gastrohub_app/src/core/utils/logger.dart';

class AppConfig {
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:8080';
  static String get stripeKey =>
      dotenv.env['STRIPE_KEY'] ?? 'tu_clave_de_stripe';
  static bool get isProduction => dotenv.env['ENV'] == 'production';
  //static const int apiTimeoutSeconds = 30;

  static Future<void> initialize() async {
    if (!kReleaseMode) {
      // En modo debug (flutter run) intenta cargar .env.local
      try {
        await dotenv.load(fileName: '.env.local');
        AppLogger.debug(".env.local cargado (modo debug)");
      } catch (_) {
        await dotenv.load(fileName: '.env');
        AppLogger.debug(".env.local no encontrado, usando .env (modo debug)");
      }
    } else {
      // En modo release (flutter build) carga siempre .env
      await dotenv.load(fileName: '.env');
      AppLogger.debug(".env cargado (modo release)");
    }
  }
}
