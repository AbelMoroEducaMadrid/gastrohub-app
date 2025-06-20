import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/snackbar_utils.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_button.dart';
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

      if (_currentOrder.state == 'pendiente' &&
          _currentOrder.items.any((item) => item.state == 'preparando')) {
        _updateOrderState('preparando');
      }

      ref.read(orderNotifierProvider.notifier).loadOrders();
    } catch (e) {
      SnackbarUtils.showAwesomeSnackbar(
        context: context,
        title: 'Error',
        message: 'Error al actualizar estado del ítem: $e',
        contentType: ContentType.failure,
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
      SnackbarUtils.showAwesomeSnackbar(
        context: context,
        title: 'Error',
        message: 'Error al actualizar estado de la comanda: $e',
        contentType: ContentType.failure,
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
SnackbarUtils.showAwesomeSnackbar(
  context: context,
  title: 'Error',
  message: 'Error al actualizar pago: $e',
  contentType: ContentType.failure,
);

    }
  }

  Future<void> _confirmCancelOrder() async {
    if (_currentOrder.state == 'servida') {
SnackbarUtils.showAwesomeSnackbar(
  context: context,
  title: 'Advertencia',
  message: 'No se puede cancelar una comanda servida',
  contentType: ContentType.warning,
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
SnackbarUtils.showAwesomeSnackbar(
  context: context,
  title: 'Advertencia',
  message: 'No se puede cancelar un ítem que ya está listo',
  contentType: ContentType.warning,
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

  Widget? _buildFab() {
    final userRole = ref.read(authProvider).user?.role;

    const allowedRoles = [
      'ROLE_WAITER',
      'ROLE_MANAGER',
      'ROLE_OWNER',
      'ROLE_ADMIN'
    ];

    if (!allowedRoles.contains(userRole)) {
      return null;
    }

    if (_currentOrder.state == 'preparando') {
      final canMarkAsServida = _canMarkAsServida();
      return FloatingActionButton(
        onPressed: canMarkAsServida ? () => _updateOrderState('servida') : null,
        backgroundColor: canMarkAsServida ? Colors.green : Colors.grey,
        child: const Icon(Icons.check, color: Colors.white),
      );
    }

    return null;
  }

  List<Widget> _buildItemActionButtons(OrderItem item) {
    List<Widget> buttons = [];

    Widget buildActionButton({
      required Color color,
      required IconData icon,
      required VoidCallback onTap,
      BorderRadius? borderRadius,
    }) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Material(
          color: color,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 50,
              height: double.infinity,
              child: Center(
                child: Icon(icon, color: Colors.white, size: 30),
              ),
            ),
          ),
        ),
      );
    }

    switch (item.state ?? 'pendiente') {
      case 'pendiente':
        buttons.add(
          buildActionButton(
            color: Colors.orange,
            icon: Icons.play_arrow_outlined,
            onTap: () => _updateItemState(item.id!, 'preparando'),
          ),
        );
        break;
      case 'preparando':
        buttons.add(
          buildActionButton(
            color: Colors.green,
            icon: Icons.check,
            onTap: () => _updateItemState(item.id!, 'listo'),
          ),
        );
        break;
    }

    if (item.state != 'listo' && item.state != 'cancelada') {
      buttons.add(
        buildActionButton(
          color: Colors.red,
          icon: Icons.cancel_outlined,
          onTap: () => _confirmCancelItem(item),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
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
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Comanda #${_currentOrder.id} - Mesa: ${_currentOrder.tableNumber ?? 'Barra'}',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_currentOrder.urgent)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.notification_important, color: Colors.red),
              ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(_currentOrder.state.toUpperCase(),
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.payment_outlined,
                                color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              '${_currentOrder.paymentState} - ${_currentOrder.paymentMethod}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        if (_currentOrder.notes != null &&
                            _currentOrder.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.note_outlined,
                                  color: Colors.black),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_currentOrder.notes}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.paid_outlined,
                                color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              '${_currentOrder.total.toStringAsFixed(2)} €',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        if (_currentOrder.state == 'servida' &&
                            _currentOrder.paymentState != 'completado') ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: () =>
                                  _updatePayment('completado', 'efectivo'),
                              text: 'Pagar (Efectivo)',
                              iconData: Icons.payments_outlined,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_currentOrder.paymentState == 'completado')
                    const Icon(Icons.paid, color: Colors.green, size: 40)
                  else if (_currentOrder.state != 'servida' &&
                      _currentOrder.state != 'cancelada')
                    IconButton(
                      icon:
                          const Icon(Icons.cancel, color: Colors.red, size: 40),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    if (item.notes != null &&
                                        item.notes!.isNotEmpty)
                                      Text('${item.notes}',
                                          style: const TextStyle(
                                              color: Colors.black)),
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
