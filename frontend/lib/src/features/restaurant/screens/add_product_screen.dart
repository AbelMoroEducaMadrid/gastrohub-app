import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_dropdown_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/component_selector.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/product_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/category_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int? _selectedCategoryId;
  bool _available = true;
  bool _isKitchen = true;
  final List<Map<String, Object>> _ingredients = [];

  String? _imageBase64;
  Uint8List? _imagePreviewBytes;

  @override
  void initState() {
    super.initState();
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
          'Añadir Producto',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImageSource,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Seleccionar Imagen'),
            ),
            const SizedBox(height: 16),
            if (_imagePreviewBytes != null)
              Center(
                child: Image.memory(
                  _imagePreviewBytes!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
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
        // TODO - añadir la imagen base64
        //'imageBase64': _imageBase64 ?? null,
      };
      ref.read(productNotifierProvider.notifier).addProduct(body);
      Navigator.pop(context);
    }
  }
}
