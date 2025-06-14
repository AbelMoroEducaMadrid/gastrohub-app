import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/features/restaurant/services/category_service.dart';
import 'package:gastrohub_app/src/features/restaurant/models/category.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final CategoryService _categoryService;
  final String _token;
  final Ref _ref;

  CategoryNotifier(this._categoryService, this._token, this._ref)
      : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      state = const AsyncValue.loading();
      final categories = await _categoryService.getAllCategories(_token);
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      AppLogger.error('Failed to load categories: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  final categoryService = ref.watch(categoryServiceProvider);
  final authState = ref.watch(authProvider);
  final token = authState.token ?? '';
  return CategoryNotifier(categoryService, token, ref);
});

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  return CategoryService(baseUrl: baseUrl);
});
