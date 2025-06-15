import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_order_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/order_detail_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/edit_order_screen.dart';

class TableOrdersScreen extends ConsumerStatefulWidget {
  final int tableId;

  const TableOrdersScreen({super.key, required this.tableId});

  @override
  ConsumerState<TableOrdersScreen> createState() => _TableOrdersScreenState();
}

class _TableOrdersScreenState extends ConsumerState<TableOrdersScreen> {
  final List<String> _allowedRoles = [
    'ROLE_ADMIN',
    'ROLE_OWNER',
    'ROLE_MANAGER',
    'ROLE_WAITER'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(tableOrderNotifierProvider(widget.tableId).notifier)
          .loadOrders();
    });
  }

  Icon _getStateIcon(String? state) {
    switch (state ?? 'pendiente') {
      case 'pendiente':
        return const Icon(Icons.hourglass_empty, color: Colors.grey);
      case 'preparando':
        return const Icon(Icons.autorenew, color: Colors.orange);
      case 'servida':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'cancelada':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userRole = authState.user?.role ?? '';
    final canEdit = _allowedRoles.contains(userRole);

    final ordersAsync = ref.watch(tableOrderNotifierProvider(widget.tableId));

    return Scaffold(
      appBar: AppBar(title: Text('Comandas de Mesa ${widget.tableId}')),
      body: ordersAsync.when(
        data: (orders) {
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _getStateIcon(order.state),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Comanda #${order.id} - Mesa ${order.tableNumber ?? "N/A"}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                    if (order.urgent)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(
                                            Icons.notification_important,
                                            color: Colors.red),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.payment_outlined,
                                            color: Colors.black),
                                        const SizedBox(width: 4),
                                        Text(order.paymentState,
                                            style: const TextStyle(
                                                color: Colors.black54)),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Row(
                                      children: [
                                        const Icon(Icons.fastfood_outlined,
                                            color: Colors.black),
                                        const SizedBox(width: 4),
                                        Text('${order.items.length}',
                                            style: const TextStyle(
                                                color: Colors.black54)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.paid_outlined,
                                        color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text('${order.total.toStringAsFixed(2)} €',
                                        style: const TextStyle(
                                            color: Colors.black54)),
                                  ],
                                ),
                                if (order.notes != null &&
                                    order.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.note_outlined,
                                          color: Colors.black),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text('${order.notes}',
                                            style: const TextStyle(
                                                color: Colors.black54)),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (canEdit)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: Container(
                              width: 50,
                              color: Colors.blue,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditOrderScreen(order: order),
                                    ),
                                  );
                                },
                                child: const Center(
                                  child: Icon(Icons.edit_outlined,
                                      color: Colors.white, size: 30),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
            child: Text('Error: $error',
                style: const TextStyle(color: Colors.black))),
      ),
    );
  }
}
