import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/ingredient_service.dart';
import 'package:gastrohub_app/src/features/restaurant/models/unit.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class UnitNotifier extends StateNotifier<List<Unit>> {
  final IngredientService _ingredientService;
  final String _token;

  UnitNotifier(this._ingredientService, this._token) : super([]);

  Future<void> loadUnits() async {
    try {
      state = await _ingredientService.getAllUnits(_token);
    } catch (e) {
      AppLogger.error('Failed to load units: $e');
    }
  }
}

final unitNotifierProvider =
    StateNotifierProvider<UnitNotifier, List<Unit>>((ref) {
  final ingredientService = ref.watch(ingredientServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return UnitNotifier(ingredientService, token);
});