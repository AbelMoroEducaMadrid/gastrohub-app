import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/ingredient_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/restaurant/models/ingredient.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class IngredientNotifier extends StateNotifier<List<Ingredient>> {
  final IngredientService _ingredientService;
  final String _token;

  IngredientNotifier(this._ingredientService, this._token) : super([]);

  Future<void> loadIngredients() async {
    try {
      state = await _ingredientService.getAllIngredients(_token);
    } catch (e) {
      AppLogger.error('Failed to load ingredients: $e');
    }
  }

  Future<void> addIngredient(Map<String, dynamic> body) async {
    try {
      final newIngredient = await _ingredientService.createIngredient(_token, body);
      state = [...state, newIngredient];
    } catch (e) {
      AppLogger.error('Failed to add ingredient: $e');
    }
  }
}

final ingredientNotifierProvider =
    StateNotifierProvider<IngredientNotifier, List<Ingredient>>((ref) {
  final ingredientService = ref.watch(ingredientServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return IngredientNotifier(ingredientService, token);
});

final ingredientServiceProvider = Provider<IngredientService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return IngredientService(baseUrl: baseUrl);
});