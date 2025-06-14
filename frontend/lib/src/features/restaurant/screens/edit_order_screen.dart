import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/features/auth/models/order.dart';
import 'package:gastrohub_app/src/features/restaurant/models/layout.dart';
import 'package:gastrohub_app/src/features/restaurant/models/table.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/layout_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/order_provider.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/select_product_screen.dart';

class EditOrderScreen extends ConsumerStatefulWidget {
  final Order order;

  const EditOrderScreen({super.key, required this.order});

  @override
  ConsumerState<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends ConsumerState<EditOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  late bool _urgent;
  late List<Map<String, dynamic>> _items;
  int? _selectedLayoutId;
  int? _selectedTableId;
  List<Layout> _layouts = [];
  List<RestaurantTable> _tables = [];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.order.notes);
    _urgent = widget.order.urgent;
    _items = widget.order.items.map((item) {
      return {
        'productId': item.productId,
        'productName': item.productName,
        'quantity': item.quantity,
        'notes': item.notes,
      };
    }).toList();
    _selectedTableId = widget.order.tableId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLayouts();
      if (widget.order.tableId != null) {
        _loadTablesForExistingOrder();
      }
    });
  }

  Future<void> _loadLayouts() async {
    final restaurantId = ref.read(authProvider).user!.restaurantId!;
    final layoutNotifier =
        ref.read(layoutNotifierProvider(restaurantId).notifier);
    await layoutNotifier.loadLayouts();
    setState(() {
      _layouts = ref.read(layoutNotifierProvider(restaurantId));
    });
  }

  Future<void> _loadTablesForExistingOrder() async {
    final layoutId = await _getLayoutIdFromTableId(widget.order.tableId!);
    if (layoutId != null) {
      setState(() {
        _selectedLayoutId = layoutId;
      });
      await _loadTables(layoutId);
    }
  }

  Future<int?> _getLayoutIdFromTableId(int tableId) async {
    final restaurantId = ref.read(authProvider).user!.restaurantId!;
    final layouts = ref.read(layoutNotifierProvider(restaurantId));
    for (var layout in layouts) {
      final tables = await ref
          .read(tableNotifierProvider(layout.id).notifier)
          .loadTables()
          .then((_) => ref.read(tableNotifierProvider(layout.id)));
      if (tables.any((table) => table.id == tableId)) {
        return layout.id;
      }
    }
    return null;
  }

  Future<void> _loadTables(int layoutId) async {
    final tableNotifier = ref.read(tableNotifierProvider(layoutId).notifier);
    await tableNotifier.loadTables();
    setState(() {
      _tables = ref.read(tableNotifierProvider(layoutId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Editar Comanda', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Layout'),
              value: _selectedLayoutId,
              items: _layouts.map((layout) {
                return DropdownMenuItem<int>(
                  value: layout.id,
                  child: Text(layout.name,
                      style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLayoutId = value;
                  _selectedTableId = null;
                  _tables = [];
                  if (value != null) {
                    _loadTables(value);
                  }
                });
              },
            ),
            if (_selectedLayoutId != null)
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Mesa'),
                value: _selectedTableId,
                items: _tables.map((table) {
                  return DropdownMenuItem<int>(
                    value: table.id,
                    child: Text('Mesa ${table.number}',
                        style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTableId = value;
                  });
                },
              ),
            CustomTextField(
              label: 'Notas',
              controller: _notesController,
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            SwitchListTile(
              title:
                  const Text('Urgente', style: TextStyle(color: Colors.black)),
              value: _urgent,
              onChanged: (value) => setState(() => _urgent = value),
            ),
            OrderItemSelector(
              items: _items,
              onAddItem: (item) => setState(() => _items.add(item)),
              onRemoveItem: (index) => setState(() => _items.removeAt(index)),
            ),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se puede guardar una comanda sin productos')),
        );
        return;
      }
      final restaurantId = ref.read(authProvider).user!.restaurantId!;
      final body = {
        'restaurantId': restaurantId,
        'tableId': _selectedTableId ?? widget.order.tableId,
        'notes': _notesController.text,
        'urgent': _urgent,
        'items': _items
            .map((item) => {
                  'productId': item['productId'],
                  'quantity': item['quantity'],
                  'notes': item['notes'],
                })
            .toList(),
      };
      ref
          .read(orderNotifierProvider.notifier)
          .updateOrder(widget.order.id, body);
      Navigator.pop(context);
    }
  }
}

class OrderItemSelector extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onAddItem;
  final Function(int) onRemoveItem;

  const OrderItemSelector({
    Key? key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Items',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return ListTile(
            title: Text(item['productName'],
                style: const TextStyle(color: Colors.black)),
            subtitle: Text(
                'Cantidad: ${item['quantity']}, Notas: ${item['notes'] ?? ''}',
                style: const TextStyle(color: Colors.black54)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: () => onRemoveItem(index),
            ),
          );
        }),
        ElevatedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectProductScreen(
                  onSelect: (product, quantity, notes) {
                    onAddItem({
                      'productId': product.id,
                      'productName': product.name,
                      'quantity': quantity,
                      'notes': notes,
                    });
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          child: const Text('Añadir Item'),
        ),
      ],
    );
  }
}
