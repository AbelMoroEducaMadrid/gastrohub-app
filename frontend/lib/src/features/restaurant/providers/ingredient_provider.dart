import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/ingredient_service.dart';
import 'package:gastrohub_app/src/features/restaurant/models/ingredient.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

final nonCompositeIngredientsProvider =
    StateProvider<AsyncValue<List<Ingredient>>>(
        (ref) => const AsyncValue.loading());

class IngredientNotifier extends StateNotifier<AsyncValue<List<Ingredient>>> {
  final IngredientService _ingredientService;
  final String _token;
  final Ref _ref;

  IngredientNotifier(this._ingredientService, this._token, this._ref)
      : super(const AsyncValue.loading()) {
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    try {
      state = const AsyncValue.loading();
      final ingredients = await _ingredientService.getAllIngredients(_token);
      state = AsyncValue.data(ingredients);
    } catch (e, stack) {
      AppLogger.error('Failed to load ingredients: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadNonCompositeIngredients() async {
    try {
      _ref.read(nonCompositeIngredientsProvider.notifier).state =
          const AsyncValue.loading();
      final ingredients =
          await _ingredientService.getNonCompositeIngredients(_token);
      _ref.read(nonCompositeIngredientsProvider.notifier).state =
          AsyncValue.data(ingredients);
      AppLogger.debug(
          'Ingredientes no compuestos cargados: ${ingredients.length}');
    } catch (e, stack) {
      AppLogger.error('Failed to load non-composite ingredients: $e');
      _ref.read(nonCompositeIngredientsProvider.notifier).state =
          AsyncValue.error(e, stack);
    }
  }

  Future<void> addIngredient(Map<String, dynamic> body) async {
    try {
      final newIngredient =
          await _ingredientService.createIngredient(_token, body);
      state = AsyncValue.data([...state.value ?? [], newIngredient]);
    } catch (e) {
      AppLogger.error('Failed to add ingredient: $e');
    }
  }
}

final ingredientNotifierProvider =
    StateNotifierProvider<IngredientNotifier, AsyncValue<List<Ingredient>>>(
        (ref) {
  final ingredientService = ref.watch(ingredientServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return IngredientNotifier(ingredientService, token, ref);
});

final ingredientServiceProvider = Provider<IngredientService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return IngredientService(baseUrl: baseUrl);
});
