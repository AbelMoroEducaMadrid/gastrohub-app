import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/product_service.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;
  final String _token;
  // ignore: unused_field
  final Ref _ref;

  ProductNotifier(this._productService, this._token, this._ref)
      : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncValue.loading();
      final products = await _productService.getAllProducts(_token);
      state = AsyncValue.data(products);
    } catch (e, stack) {
      AppLogger.error('Failed to load products: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addProduct(Map<String, dynamic> body) async {
    try {
      final newProduct = await _productService.createProduct(_token, body);
      state = AsyncValue.data([...state.value ?? [], newProduct]);
    } catch (e) {
      AppLogger.error('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> body) async {
    try {
      final updatedProduct =
          await _productService.updateProduct(_token, id, body);
      state = AsyncValue.data(
        state.value
                ?.map((prod) => prod.id == id ? updatedProduct : prod)
                .toList() ??
            [updatedProduct],
      );
    } catch (e) {
      AppLogger.error('Failed to update product: $e');
    }
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  final productService = ref.watch(productServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return ProductNotifier(productService, token, ref);
});

final productServiceProvider = Provider<ProductService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return ProductService(baseUrl: baseUrl);
});
