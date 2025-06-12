import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/layout_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/restaurant/models/layout.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class LayoutNotifier extends StateNotifier<List<Layout>> {
  final LayoutService _layoutService;
  final String _token;
  final int _restaurantId;

  LayoutNotifier(this._layoutService, this._token, this._restaurantId)
      : super([]);

  Future<void> loadLayouts() async {
    try {
      state =
          await _layoutService.getAllLayoutsByRestaurant(_token, _restaurantId);
    } catch (e) {
      AppLogger.error('Failed to load layouts: $e');
    }
  }

  Future<void> addLayout(String name) async {
    try {
      final newLayout =
          await _layoutService.createLayout(_token, name, _restaurantId);
      state = [...state, newLayout];
    } catch (e) {
      AppLogger.error('Failed to add layout: $e');
    }
  }

  Future<void> updateLayout(int layoutId, String name) async {
    try {
      final updatedLayout =
          await _layoutService.updateLayout(_token, layoutId, name);
      state = state
          .map((layout) => layout.id == layoutId ? updatedLayout : layout)
          .toList();
    } catch (e) {
      AppLogger.error('Failed to update layout: $e');
    }
  }

  Future<void> deleteLayout(int layoutId) async {
    try {
      await _layoutService.deleteLayout(_token, layoutId);
      state = state.where((layout) => layout.id != layoutId).toList();
    } catch (e) {
      AppLogger.error('Failed to delete layout: $e');
    }
  }
}

final layoutNotifierProvider =
    StateNotifierProvider.family<LayoutNotifier, List<Layout>, int>(
        (ref, restaurantId) {
  final layoutService = ref.watch(layoutServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return LayoutNotifier(layoutService, token, restaurantId);
});

final layoutServiceProvider = Provider<LayoutService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return LayoutService(baseUrl: baseUrl);
});

final activeLayoutProvider = StateProvider<int?>((ref) => null);
