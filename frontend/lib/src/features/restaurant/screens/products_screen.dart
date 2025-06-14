import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/models/category.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/add_product_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/edit_product_screen.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final List<String> _allowedRoles = [
    'ROLE_ADMIN',
    'ROLE_OWNER',
    'ROLE_MANAGER'
  ];

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
    final authState = ref.watch(authProvider);
    final userRole = authState.user?.role ?? '';
    final canEdit = _allowedRoles.contains(userRole);

    final productsAsync = ref.watch(productNotifierProvider);
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos',
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.grey[100],
                  collapsedBackgroundColor: Colors.grey[200],
                  children: categoryProducts.map((product) {
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          product.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(2)} €',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            if (!product.available)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'No disponible',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                        trailing: canEdit
                            ? IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProductScreen(product: product),
                                    ),
                                  );
                                },
                              )
                            : null,
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
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => _addProduct(context),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
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
