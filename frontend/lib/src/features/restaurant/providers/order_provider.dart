import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/auth/models/order.dart';
import 'package:gastrohub_app/src/features/restaurant/services/order_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderService _orderService;
  final String _token;
  final Ref _ref;

  OrderNotifier(this._orderService, this._token, this._ref)
      : super(const AsyncValue.loading()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      state = const AsyncValue.loading();
      final orders = await _orderService.getAllOrders(_token);
      state = AsyncValue.data(orders);
    } catch (e, stack) {
      AppLogger.error('Failed to load orders: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addOrder(Map<String, dynamic> body) async {
    try {
      final newOrder = await _orderService.createOrder(_token, body);
      state = AsyncValue.data([...state.value ?? [], newOrder]);
    } catch (e) {
      AppLogger.error('Failed to add order: $e');
    }
  }

  Future<void> updateOrder(int id, Map<String, dynamic> body) async {
    try {
      final updatedOrder = await _orderService.updateOrder(_token, id, body);
      state = AsyncValue.data(
        state.value
                ?.map((order) => order.id == id ? updatedOrder : order)
                .toList() ??
            [updatedOrder],
      );
    } catch (e) {
      AppLogger.error('Failed to update order: $e');
    }
  }
}

final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>((ref) {
  final orderService = ref.watch(orderServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return OrderNotifier(orderService, token, ref);
});

final orderServiceProvider = Provider<OrderService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return OrderService(baseUrl: baseUrl);
});
