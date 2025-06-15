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
      final body = {'newState': newState};
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

  Future<void> _confirmCancelOrder() async {
    if (_currentOrder.state == 'servida') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se puede cancelar una comanda servida')),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cancelación'),
        content:
            const Text('¿Estás seguro de que quieres cancelar esta comanda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _updateOrderState('cancelada');
    }
  }

  Future<void> _confirmCancelItem(OrderItem item) async {
    if (item.state == 'listo') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se puede cancelar un ítem que ya está listo')),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cancelación'),
        content: const Text('¿Estás seguro de que quieres cancelar este ítem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _updateItemState(item.id!, 'cancelada');
    }
  }

  bool _canMarkAsServida() {
    return _currentOrder.items
        .every((item) => item.state == 'listo' || item.state == 'cancelada');
  }

  Widget _buildOrderActionButtons() {
    switch (_currentOrder.state) {
      case 'pendiente':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.orange),
              onPressed: () => _updateOrderState('preparando'),
              tooltip: 'Iniciar preparación',
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _confirmCancelOrder(),
              tooltip: 'Cancelar comanda',
            ),
          ],
        );
      case 'preparando':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: _canMarkAsServida()
                  ? () => _updateOrderState('servida')
                  : null,
              tooltip: 'Marcar como servida',
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _confirmCancelOrder(),
              tooltip: 'Cancelar comanda',
            ),
          ],
        );
      case 'servida':
      case 'cancelada':
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildItemActionButtons(OrderItem item) {
    switch (item.state ?? 'pendiente') {
      case 'pendiente':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.orange),
              onPressed: () => _updateItemState(item.id!, 'preparando'),
              tooltip: 'Iniciar preparación',
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _confirmCancelItem(item),
              tooltip: 'Cancelar ítem',
            ),
          ],
        );
      case 'preparando':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _updateItemState(item.id!, 'listo'),
              tooltip: 'Marcar como listo',
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _confirmCancelItem(item),
              tooltip: 'Cancelar ítem',
            ),
          ],
        );
      case 'listo':
      case 'cancelada':
      default:
        return const SizedBox.shrink();
    }
  }

  Icon _getStateIcon(String? state) {
    switch (state ?? 'pendiente') {
      case 'pendiente':
        return const Icon(Icons.hourglass_empty, color: Colors.grey);
      case 'preparando':
        return const Icon(Icons.autorenew, color: Colors.orange);
      case 'listo':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'cancelada':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.black);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Acciones:'),
                      _buildOrderActionButtons(),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _currentOrder.state == 'servida'
                        ? () => _updatePayment('completado', 'efectivo')
                        : null,
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
                leading: _getStateIcon(item.state),
                title: Text(item.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cantidad: ${item.quantity}'),
                    if (item.notes != null) Text('Notas: ${item.notes}'),
                  ],
                ),
                trailing: _buildItemActionButtons(item),
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
