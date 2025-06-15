import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/auth/models/order.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/order_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/services/order_service.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class TableOrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderService _orderService;
  final String _token;
  final int _tableId;

  TableOrderNotifier(this._orderService, this._token, this._tableId)
      : super(const AsyncValue.loading()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      state = const AsyncValue.loading();
      final orders = await _orderService.getOrdersByTable(_token, _tableId);
      state = AsyncValue.data(orders);
    } catch (e, stack) {
      AppLogger.error('Failed to load orders for table $_tableId: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}

final tableOrderNotifierProvider = StateNotifierProvider.family<
    TableOrderNotifier, AsyncValue<List<Order>>, int>((ref, tableId) {
  final orderService = ref.watch(orderServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return TableOrderNotifier(orderService, token, tableId);
});
