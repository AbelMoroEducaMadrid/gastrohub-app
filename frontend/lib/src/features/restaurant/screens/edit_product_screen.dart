import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_dropdown_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/component_selector.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  int? _selectedCategoryId;
  late bool _available;
  late bool _isKitchen;
  late List<Map<String, Object>> _ingredients;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _selectedCategoryId = widget.product.categoryId;
    _available = widget.product.available;
    _isKitchen = widget.product.isKitchen;
    _ingredients = widget.product.ingredients
            ?.map((i) => <String, Object>{
                  'componentIngredientId': i.ingredientId,
                  'name': i.ingredientName,
                  'quantity': i.quantity,
                })
            .toList() ??
        [];
    Future.microtask(() {
      ref
          .read(ingredientNotifierProvider.notifier)
          .loadNonCompositeIngredients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);
    final ingredientsAsync = ref.watch(nonCompositeIngredientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              label: 'Nombre',
              controller: _nameController,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            categoriesAsync.when(
              data: (categories) => CustomDropdownField<int>(
                label: 'Categoría',
                value: _selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategoryId = value),
                validator: (value) => value == null ? 'Requerido' : null,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            CustomTextField(
              label: 'Precio',
              controller: _priceController,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            SwitchListTile(
              title: const Text('Disponible'),
              value: _available,
              onChanged: (value) => setState(() => _available = value),
            ),
            SwitchListTile(
              title: const Text('Es de cocina'),
              value: _isKitchen,
              onChanged: (value) => setState(() => _isKitchen = value),
            ),
            ingredientsAsync.when(
              data: (ingredients) => ComponentSelector(
                components: _ingredients,
                nonCompositeIngredients: ingredients,
                onAddComponent: (component) {
                  setState(() => _ingredients.add(component));
                },
                onRemoveComponent: (index) {
                  setState(() => _ingredients.removeAt(index));
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final body = <String, Object>{
        'name': _nameController.text,
        'categoryId': _selectedCategoryId as Object,
        'price': double.parse(_priceController.text),
        'available': _available,
        'isKitchen': _isKitchen,
        'ingredients': _ingredients
            .map((i) => <String, Object>{
                  'ingredientId': i['componentIngredientId'] as Object,
                  'quantity': i['quantity'] as Object,
                })
            .toList(),
      };
      ref
          .read(productNotifierProvider.notifier)
          .updateProduct(widget.product.id, body);
      Navigator.pop(context);
    }
  }
}
