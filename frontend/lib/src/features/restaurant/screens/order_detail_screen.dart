import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/models/order.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/order_provider.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  late Order _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  Future<void> _updateItemState(int itemId, String newState) async {
    try {
      final body = {'newState': newState};
      await ref.read(orderServiceProvider).updateOrderItemState(
          ref.read(authProvider).token ?? '', _currentOrder.id, itemId, body);
      setState(() {
        _currentOrder = _currentOrder.copyWith(
          items: _currentOrder.items.map((item) {
            return item.id == itemId ? item.copyWith(state: newState) : item;
          }).toList(),
        );
      });
      ref.read(orderNotifierProvider.notifier).loadOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar estado del ítem: $e')),
      );
    }
  }

  Future<void> _updateOrderState(String newState) async {
    try {
      final body = {'state': newState};
      final updatedOrder = await ref
          .read(orderServiceProvider)
          .updateOrderState(
              ref.read(authProvider).token ?? '', _currentOrder.id, body);
      setState(() {
        _currentOrder = updatedOrder;
      });
      ref.read(orderNotifierProvider.notifier).loadOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar estado de la comanda: $e')),
      );
    }
  }

  Future<void> _updatePayment(String paymentState, String paymentMethod) async {
    try {
      final body = {
        'paymentState': paymentState,
        'paymentMethod': paymentMethod,
      };
      final updatedOrder = await ref
          .read(orderServiceProvider)
          .updateOrderPayment(
              ref.read(authProvider).token ?? '', _currentOrder.id, body);
      setState(() {
        _currentOrder = updatedOrder;
      });
      ref.read(orderNotifierProvider.notifier).loadOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar pago: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comanda #${_currentOrder.id}',
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Mesa: ${_currentOrder.tableNumber ?? 'Barra'}${_currentOrder.urgent ? ' (Urgente)' : ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Estado: ${_currentOrder.state}'),
                  Text(
                      'Pago: ${_currentOrder.paymentState} - ${_currentOrder.paymentMethod}'),
                  if (_currentOrder.notes != null)
                    Text('Notas: ${_currentOrder.notes}'),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _currentOrder.state,
                    items: ['pendiente', 'preparando', 'servida', 'cancelada']
                        .map((state) => DropdownMenuItem(
                              value: state,
                              child: Text(state.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null && value != _currentOrder.state) {
                        _updateOrderState(value);
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _updatePayment('completado', 'efectivo'),
                    child: const Text('Marcar como Pagado (Efectivo)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),          
          ..._currentOrder.items.map((item) {
            return Card(
              child: ListTile(
                title: Text(item.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado: ${item.state ?? 'pending'}'),
                    Text('Cantidad: ${item.quantity}'),
                    if (item.notes != null) Text('Notas: ${item.notes}'),
                  ],
                ),
                trailing: DropdownButton<String>(
                  value: item.state ?? 'pending',
                  items: ['pendiente', 'preparando', 'listo', 'cancelado']
                      .map((state) => DropdownMenuItem(
                            value: state,
                            child: Text(state.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null && value != item.state) {
                      _updateItemState(item.id!, value);
                    }
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

extension OrderCopy on Order {
  Order copyWith({
    List<OrderItem>? items,
    String? state,
    String? paymentState,
    String? paymentMethod,
  }) {
    return Order(
      id: id,
      tableId: tableId,
      tableNumber: tableNumber,
      layout: layout,
      notes: notes,
      urgent: urgent,
      state: state ?? this.state,
      paymentState: paymentState ?? this.paymentState,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      total: total,
    );
  }
}

extension OrderItemCopy on OrderItem {
  OrderItem copyWith({String? state}) {
    return OrderItem(
      id: id,
      productId: productId,
      productName: productName,
      price: price,
      notes: notes,
      state: state ?? this.state,
      quantity: quantity,
    );
  }
}
