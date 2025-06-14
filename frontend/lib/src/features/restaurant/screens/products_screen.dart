import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    String ingredientsText = '';
                    if (product.ingredients != null &&
                        product.ingredients!.length > 1) {
                      ingredientsText =
                          'ING: ${product.ingredients!.map((i) => i.ingredientName.toLowerCase()).join(', ')}';
                    }
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            Row(
                              children: product.attributes.map((attr) {
                                final iconPath =
                                    'assets/images/allergens/$attr.svg';
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: SvgPicture.asset(
                                    iconPath,
                                    width: 24,
                                    height: 24,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (ingredientsText.isNotEmpty)
                              Text(
                                ingredientsText,
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${product.price.toStringAsFixed(2)} €',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                if (!product.available)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      'AGOTADO',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
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
      final categoryProducts = products
          .where((product) => product.categoryId == category.id)
          .toList();
      if (categoryProducts.isNotEmpty) {
        categorized[category] = categoryProducts;
      }
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
