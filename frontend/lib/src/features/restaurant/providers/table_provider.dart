import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/table_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/restaurant/models/table.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class TableNotifier extends StateNotifier<List<RestaurantTable>> {
  final TableService _tableService;
  final String _token;
  final int _layoutId;

  TableNotifier(this._tableService, this._token, this._layoutId) : super([]);

  Future<void> loadTables() async {
    try {
      state = await _tableService.getAllTablesByLayout(_token, _layoutId);
    } catch (e) {
      AppLogger.error('Failed to load tables: $e');
    }
  }

  Future<void> addTable(int number, int capacity) async {
    try {
      final newTable = await _tableService.createTable(
          _token, _layoutId, number, capacity);
      state = [...state, newTable];
    } catch (e) {
      AppLogger.error('Failed to add table: $e');
    }
  }

  Future<void> updateTable(int id, RestaurantTable updatedTable) async {
  try {
    final table = await _tableService.updateTable(_token, id, updatedTable);
    state = state.map((t) => t.id == id ? table : t).toList();
  } catch (e) {
    AppLogger.error('Failed to update table: $e');
  }
}
}

final tableNotifierProvider =
    StateNotifierProvider.family<TableNotifier, List<RestaurantTable>, int>(
        (ref, layoutId) {
  final tableService = ref.watch(tableServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return TableNotifier(tableService, token, layoutId);
});

final tableServiceProvider = Provider<TableService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return TableService(baseUrl: baseUrl);
});
