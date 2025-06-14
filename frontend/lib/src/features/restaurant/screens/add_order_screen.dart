import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/order_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class AddOrderScreen extends ConsumerStatefulWidget {
  const AddOrderScreen({super.key});

  @override
  ConsumerState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends ConsumerState<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  bool _urgent = false;
  final List<Map<String, dynamic>> _items = [];

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Añadir Comanda', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
            productsAsync.when(
              data: (products) => OrderItemSelector(
                items: _items,
                products: products,
                onAddItem: (item) => setState(() => _items.add(item)),
                onRemoveItem: (index) => setState(() => _items.removeAt(index)),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Añadir'),
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
              content: Text('No se puede crear una comanda sin productos')),
        );
        return;
      }
      final restaurantId = ref.read(authProvider).user!.restaurantId!;
      final body = {
        'restaurantId': restaurantId,
        'tableId': null, // Para comandas de barra
        'notes': _notesController.text,
        'urgent': _urgent,
        'items': _items
            .map((item) => {
                  'productId': item['productId'],
                  'quantity': item['quantity'],
                  'price': item['price'],
                  'notes': item['notes'],
                })
            .toList(),
      };
      ref.read(orderNotifierProvider.notifier).addOrder(body);
      Navigator.pop(context);
    }
  }
}

class OrderItemSelector extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final List<Product> products;
  final Function(Map<String, dynamic>) onAddItem;
  final Function(int) onRemoveItem;

  const OrderItemSelector({
    Key? key,
    required this.items,
    required this.products,
    required this.onAddItem,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final product = products.firstWhere((p) => p.id == item['productId']);
          return ListTile(
            title: Text(product.name),
            subtitle:
                Text('Cantidad: ${item['quantity']}, Precio: ${item['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onRemoveItem(index),
            ),
          );
        }),
        ElevatedButton(
          onPressed: () => _addItemDialog(context),
          child: const Text('Añadir Item'),
        ),
      ],
    );
  }

  void _addItemDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        int? selectedProductId;
        final quantityController = TextEditingController(text: '1');
        final priceController = TextEditingController();
        final notesController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Producto'),
                    value: selectedProductId,
                    items: products.map((product) {
                      return DropdownMenuItem<int>(
                        value: product.id,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProductId = value;
                        final product =
                            products.firstWhere((p) => p.id == value);
                        priceController.text = product.price.toString();
                      });
                    },
                  ),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(labelText: 'Notas'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedProductId != null) {
                        final item = {
                          'productId': selectedProductId,
                          'quantity': int.parse(quantityController.text),
                          'price': double.parse(priceController.text),
                          'notes': notesController.text,
                        };
                        onAddItem(item);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Añadir'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
