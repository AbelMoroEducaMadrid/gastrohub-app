import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/models/order.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/order_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/add_order_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/edit_order_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/order_detail_screen.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
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
      ref.read(orderNotifierProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userRole = authState.user?.role ?? '';
    final canEdit = _allowedRoles.contains(userRole);

    final ordersAsync = ref.watch(orderNotifierProvider);

    return Scaffold(
      body: ordersAsync.when(
        data: (orders) {
          final groupedOrders = _groupOrdersByLayout(orders);
          return ListView.builder(
            itemCount: groupedOrders.length,
            itemBuilder: (context, index) {
              final layout = groupedOrders.keys.elementAt(index);
              final layoutOrders = groupedOrders[layout]!;
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      layout ?? 'Barra',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '(${layoutOrders.length})',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                children: layoutOrders.map((order) {
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Comanda #${order.id} - ${order.tableNumber != null ? 'Mesa ${order.tableNumber}' : 'Barra'}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          if (order.urgent)
                            const Icon(Icons.notification_important,
                                color: Colors.red),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estado: ${order.state.toUpperCase()}',
                              style: const TextStyle(color: Colors.black54)),
                          Text('Pago: ${order.paymentState}',
                              style: const TextStyle(color: Colors.black54)),
                          Text('Total: ${order.total.toStringAsFixed(2)} €',
                              style: const TextStyle(color: Colors.black54)),
                          Text('Items: ${order.items.length}',
                              style: const TextStyle(color: Colors.black54)),
                          if (order.notes != null)
                            Text('Notas: ${order.notes}',
                                style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      trailing: canEdit
                          ? IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditOrderScreen(order: order),
                                  ),
                                );
                              },
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailScreen(order: order),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
            child: Text('Error: $error',
                style: const TextStyle(color: Colors.black))),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => _addOrder(context),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
    );
  }

  Map<String?, List<Order>> _groupOrdersByLayout(List<Order> orders) {
    final Map<String?, List<Order>> grouped = {};
    for (var order in orders) {
      final layout = order.layout;
      if (grouped.containsKey(layout)) {
        grouped[layout]!.add(order);
      } else {
        grouped[layout] = [order];
      }
    }
    return grouped;
  }

  void _addOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOrderScreen()),
    );
  }
}
