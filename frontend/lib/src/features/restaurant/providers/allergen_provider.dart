import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/allergen_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/restaurant/models/allergen.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class AllergenNotifier extends StateNotifier<List<Allergen>> {
  final AllergenService _allergenService;
  final String _token;

  AllergenNotifier(this._allergenService, this._token) : super([]);

  Future<void> loadAllergens() async {
    try {
      state = await _allergenService.getAllAllergens(_token);
    } catch (e) {
      AppLogger.error('Failed to load allergens: $e');
    }
  }
}

final allergenNotifierProvider =
    StateNotifierProvider<AllergenNotifier, List<Allergen>>((ref) {
  final allergenService = ref.watch(allergenServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return AllergenNotifier(allergenService, token);
});

final allergenServiceProvider = Provider<AllergenService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return AllergenService(baseUrl: baseUrl);
});