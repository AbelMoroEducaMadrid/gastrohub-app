import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/order_provider.dart';

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
        data: (orders) => ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ListTile(
                title: Text(
                  'Comanda #${order.id} - ${order.tableId != null ? 'Mesa ${order.tableId}' : 'Barra'}',
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado: ${order.state}',
                        style: const TextStyle(color: Colors.black54)),
                    Text('Pago: ${order.paymentState}',
                        style: const TextStyle(color: Colors.black54)),
                    Text('Items: ${order.items.length}',
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                trailing: canEdit
                    ? IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditOrderScreen(order: order),
                            ),
                          );*/
                        },
                      )
                    : null,
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error',
              style: const TextStyle(color: Colors.black)),
        ),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => _addOrder(context),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
    );
  }

  void _addOrder(BuildContext context) {
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOrderScreen()),
    );*/
  }
}
