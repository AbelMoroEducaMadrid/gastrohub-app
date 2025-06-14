import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/features/restaurant/models/category.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';

class SelectProductScreen extends ConsumerWidget {
  final Function(Product, int, String) onSelect;

  const SelectProductScreen({super.key, required this.onSelect});

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
                  title: Text(category.name,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  children: categoryProducts.map((product) {
                    String ingredientsText = '';
                    if (product.ingredients != null &&
                        product.ingredients!.length > 1) {
                      ingredientsText =
                          'ING: ${product.ingredients!.map((i) => i.ingredientName.toLowerCase()).join(', ')}';
                    }
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(product.name,
                                style: const TextStyle(color: Colors.black)),
                          ),
                          Row(
                            children: product.attributes.map((attr) {
                              final iconPath =
                                  'assets/images/allergens/$attr.svg';
                              return Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: SvgPicture.asset(iconPath,
                                    width: 24, height: 24),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ingredientsText.isNotEmpty)
                            Text(ingredientsText,
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('${product.price.toStringAsFixed(2)} €',
                                  style:
                                      const TextStyle(color: Colors.black54)),
                              if (!product.available)
                                const Padding(
                                  padding: EdgeInsets.only(left: 18.0),
                                  child: Text('AGOTADO',
                                      style: TextStyle(color: Colors.red)),
                                ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => _showQuantityDialog(context, product),
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
