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
          .updateOrderState(ref.read(authProvider).token ?? '', _currentOrder.id, body);
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
          .updateOrderPayment(ref.read(authProvider).token ?? '', _currentOrder.id, body);
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
        const SnackBar(content: Text('No se puede cancelar una comanda servida')),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cancelación'),
        content: const Text('¿Estás seguro de que quieres cancelar esta comanda?'),
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
        const SnackBar(content: Text('No se puede cancelar un ítem que ya está listo')),
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
    return _currentOrder.items.every((item) => item.state == 'listo' || item.state == 'cancelada');
  }

  Color _getOrderCardColor() {
    if (_currentOrder.paymentState == 'completado') {
      return Colors.blue.shade100;
    }
    switch (_currentOrder.state) {
      case 'servida':
        return Colors.green.shade100;
      case 'cancelada':
        return Colors.red.shade100;
      default:
        return Colors.white;
    }
  }

  Widget? _buildFab() {
    switch (_currentOrder.state) {
      case 'pendiente':
        return FloatingActionButton(
          onPressed: () => _updateOrderState('preparando'),
          backgroundColor: Colors.orange,
          child: const Icon(Icons.play_arrow, color: Colors.white),
        );
      case 'preparando':
        return FloatingActionButton(
          onPressed: _canMarkAsServida() ? () => _updateOrderState('servida') : null,
          backgroundColor: Colors.green,
          child: const Icon(Icons.check, color: Colors.white),
        );
      default:
        return null;
    }
  }

  List<Widget> _buildItemActionButtons(OrderItem item) {
    List<Widget> buttons = [];
    switch (item.state ?? 'pendiente') {
      case 'pendiente':
        buttons.add(
          Container(
            width: 50,
            height: double.infinity,
            color: Colors.orange,
            child: GestureDetector(
              onTap: () => _updateItemState(item.id!, 'preparando'),
              child: const Center(
                  child: Icon(Icons.play_arrow_outlined,
                      color: Colors.white, size: 30)),
            ),
          ),
        );
        break;
      case 'preparando':
        buttons.add(
          Container(
            width: 50,
            height: double.infinity,
            color: Colors.green,
            child: GestureDetector(
              onTap: () => _updateItemState(item.id!, 'listo'),
              child: const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 30)),
            ),
          ),
        );
        break;
    }

    if (item.state != 'listo' && item.state != 'cancelada') {
      buttons.add(
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: Container(
            width: 50,
            height: double.infinity,
            color: Colors.red,
            child: GestureDetector(
              onTap: () => _confirmCancelItem(item),
              child: const Center(
                child:
                    Icon(Icons.cancel_outlined, color: Colors.white, size: 30),
              ),
            ),
          ),
        ),
      );
    }

    return buttons;
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
            color: _getOrderCardColor(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mesa: ${_currentOrder.tableNumber ?? 'Barra'}${_currentOrder.urgent ? ' (Urgente)' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text('Estado: ${_currentOrder.state}', style: const TextStyle(color: Colors.black)),
                        Text('Pago: ${_currentOrder.paymentState} - ${_currentOrder.paymentMethod}', style: const TextStyle(color: Colors.black)),
                        if (_currentOrder.notes != null)
                          Text('Notas: ${_currentOrder.notes}', style: const TextStyle(color: Colors.black)),
                        if (_currentOrder.state == 'servida' && _currentOrder.paymentState != 'completado')
                          ElevatedButton(
                            onPressed: () => _updatePayment('completado', 'efectivo'),
                            child: const Text('Marcar como Pagado (Efectivo)', style: TextStyle(color: Colors.black)),
                          ),
                      ],
                    ),
                  ),
                  if (_currentOrder.state != 'servida' && _currentOrder.state != 'cancelada')
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => _confirmCancelOrder(),
                      tooltip: 'Cancelar comanda',
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ..._currentOrder.items.map((item) {
            return Card(
              color: _getCardColor(item.state),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 80),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _getStateIcon(item.state),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    if (item.notes != null && item.notes!.isNotEmpty)
                                      Text('${item.notes}', style: const TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ..._buildItemActionButtons(item),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }
}

Color _getCardColor(String? state) {
  switch (state) {
    case 'listo':
      return Colors.green.shade100;
    case 'cancelada':
      return Colors.red.shade100;
    default:
      return Colors.white;
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