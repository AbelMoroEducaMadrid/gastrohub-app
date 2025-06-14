import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/models/category.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/add_product_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/edit_product_screen.dart';

class ManageProductsScreen extends ConsumerStatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  ConsumerState<ManageProductsScreen> createState() =>
      _ManageProductsScreenState();
}

class _ManageProductsScreenState extends ConsumerState<ManageProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productNotifierProvider.notifier).loadProducts();
      ref.read(categoryNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productNotifierProvider);
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestionar Productos',
          style: TextStyle(color: Colors.black),
        ),
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
                    style: const TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  children: categoryProducts.map((product) {
                    return ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductScreen(product: product),
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
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProduct(context),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      backgroundColor: Colors.white,
    );
  }

  Map<Category, List<Product>> _categorizeProducts(
      List<Product> products, List<Category> categories) {
    final Map<Category, List<Product>> categorized = {};
    for (var category in categories) {
      categorized[category] = products
          .where((product) => product.categoryId == category.id)
          .toList();
    }
    return categorized;
  }

  void _addProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );
  }
}
