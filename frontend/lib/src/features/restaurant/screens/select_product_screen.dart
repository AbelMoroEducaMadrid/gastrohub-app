import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/features/restaurant/models/category.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';
import 'dart:convert';
import 'dart:typed_data';

class SelectProductScreen extends ConsumerWidget {
  final Function(Product, int, String) onSelect;

  const SelectProductScreen({super.key, required this.onSelect});

  Uint8List? _base64ToUint8List(String? base64String) {
    if (base64String == null) return null;
    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productNotifierProvider);
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Producto',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: productsAsync.when(
        data: (products) => categoriesAsync.when(
          data: (categories) {
            final categorizedProducts =
                _categorizeProducts(products, categories);
            return ListView.builder(
              itemCount: categorizedProducts.length,
              itemBuilder: (context, index) {
                final category = categorizedProducts.keys.elementAt(index);
                final categoryProducts = categorizedProducts[category]!;
                return ExpansionTile(
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  backgroundColor: Colors.grey[100],
                  collapsedBackgroundColor: Colors.grey[200],
                  children: categoryProducts.map((product) {
                    return GestureDetector(
                      onTap: () => _showQuantityDialog(context, product),
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12)),
                                child: product.imageBase64 != null
                                    ? Image.memory(
                                        _base64ToUint8List(
                                            product.imageBase64)!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[800],
                                        child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.white,
                                            size: 40),
                                      ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children:
                                            product.attributes.map((attr) {
                                          final iconPath =
                                              'assets/images/allergens/$attr.svg';
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
                                            child: SvgPicture.asset(iconPath,
                                                width: 24, height: 24),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${product.price.toStringAsFixed(2)} €',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if (!product.available)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            'AGOTADO',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
            child: Text('Error: $error',
                style: const TextStyle(color: Colors.black))),
      ),
    );
  }

  Map<Category, List<Product>> _categorizeProducts(
      List<Product> products, List<Category> categories) {
    final Map<Category, List<Product>> categorized = {};
    for (var category in categories) {
      final categoryProducts = products
          .where((product) => product.categoryId == category.id)
          .toList();
      if (categoryProducts.isNotEmpty) {
        categorized[category] = categoryProducts;
      }
    }
    return categorized;
  }

  void _showQuantityDialog(BuildContext context, Product product) {
    final quantityController = TextEditingController(text: '1');
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Añadir ${product.name}',
              style: const TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    labelStyle: TextStyle(color: Colors.black)),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                    labelText: 'Notas',
                    labelStyle: TextStyle(color: Colors.black)),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final notes = notesController.text;
                onSelect(product, quantity, notes);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child:
                  const Text('Añadir', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
