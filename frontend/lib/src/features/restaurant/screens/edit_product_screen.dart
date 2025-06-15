import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_dropdown_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/component_selector.dart';
import 'package:gastrohub_app/src/features/restaurant/models/product.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  int? _selectedCategoryId;
  late bool _available;
  late bool _isKitchen;
  late List<Map<String, Object>> _ingredients;
  String? _imageBase64;
  Uint8List? _imagePreviewBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
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
    _imageBase64 = widget.product.imageBase64;
    if (_imageBase64 != null) {
      _imagePreviewBytes = base64Decode(_imageBase64!);
    }
    Future.microtask(() {
      ref
          .read(ingredientNotifierProvider.notifier)
          .loadNonCompositeIngredients();
    });
  }

  Future<void> _pickImageSource() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Navigator.of(context).pop();
                _pickAndProcessImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.of(context).pop();
                _pickAndProcessImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndProcessImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recorta la imagen',
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Recorta la imagen'),
      ],
    );

    if (croppedFile == null) return;

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      croppedFile.path,
      quality: 60,
      minWidth: 200,
      minHeight: 200,
      format: CompressFormat.jpeg,
    );

    if (compressedBytes == null) return;

    setState(() {
      _imageBase64 = base64Encode(compressedBytes);
      _imagePreviewBytes = Uint8List.fromList(compressedBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);
    final ingredientsAsync = ref.watch(nonCompositeIngredientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Producto',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImageSource,
              child: Center(
                child: _imagePreviewBytes == null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt,
                                size: 50, color: Colors.black45),
                            SizedBox(height: 8),
                            Text(
                              'Añadir foto',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _imagePreviewBytes!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            if (_imagePreviewBytes != null)
              Center(
                child: TextButton.icon(
                  onPressed: _pickImageSource,
                  icon: const Icon(Icons.edit, color: Colors.black),
                  label: const Text(
                    'Cambiar foto',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nombre',
              controller: _nameController,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            CustomTextField(
              label: 'Descripción',
              controller: _descriptionController,
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            categoriesAsync.when(
              data: (categories) => CustomDropdownField<int>(
                label: 'Categoría',
                value: _selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(
                      category.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategoryId = value),
                validator: (value) => value == null ? 'Requerido' : null,
                textColor: Colors.black,
                borderColor: Colors.black,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            CustomTextField(
              label: 'Precio',
              controller: _priceController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Requerido';
                if (double.tryParse(value!) == null) {
                  return 'Debe ser un número';
                }
                return null;
              },
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            SwitchListTile(
              title: const Text(
                'Disponible',
                style: TextStyle(color: Colors.black),
              ),
              value: _available,
              onChanged: (value) => setState(() => _available = value),
            ),
            SwitchListTile(
              title: const Text(
                'Es de cocina',
                style: TextStyle(color: Colors.black),
              ),
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
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
      final body = <String, Object?>{
        'name': _nameController.text,
        'description': _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        'imageBase64': _imageBase64,
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
