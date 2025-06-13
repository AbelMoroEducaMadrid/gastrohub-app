import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/component_selector.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_dropdown_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/unit_provider.dart';

class AddIngredientScreen extends ConsumerStatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  ConsumerState<AddIngredientScreen> createState() =>
      _AddIngredientScreenState();
}

class _AddIngredientScreenState extends ConsumerState<AddIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _costPerUnitController = TextEditingController();
  final _minStockController = TextEditingController();
  int? _selectedUnitId;
  bool _isComposite = false;
  final List<Map<String, dynamic>> _components = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(ingredientNotifierProvider.notifier)
          .loadNonCompositeIngredients();
      ref.read(unitNotifierProvider.notifier).loadUnits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = ref.watch(unitNotifierProvider);
    final nonCompositeAsync = ref.watch(nonCompositeIngredientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Añadir ingrediente')),
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
            CustomDropdownField<int>(
              label: 'Unidad',
              value: _selectedUnitId,
              items: units.map((unit) {
                return DropdownMenuItem<int>(
                  value: unit.id,
                  child: Text(unit.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedUnitId = value),
              validator: (value) => value == null ? 'Requerido' : null,
              textColor: Colors.black,
              borderColor: Colors.black,
            ),
            CustomTextField(
              label: 'Stock',
              controller: _stockController,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            CustomTextField(
              label: 'Coste por unidad',
              controller: _costPerUnitController,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            CustomTextField(
              label: 'Stock mínimo',
              controller: _minStockController,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
              fillColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.black,
              cursorColor: Colors.black,
              placeholderColor: Colors.black54,
            ),
            SwitchListTile(
              title: const Text('Es compuesto'),
              value: _isComposite,
              onChanged: (value) => setState(() => _isComposite = value),
            ),
            if (_isComposite)
              nonCompositeAsync.when(
                data: (nonCompositeIngredients) =>
                    nonCompositeIngredients.isEmpty
                        ? const Text(
                            'No hay ingredientes no compuestos disponibles')
                        : ComponentSelector(
                            components: _components,
                            nonCompositeIngredients: nonCompositeIngredients,
                            onAddComponent: (component) {
                              setState(() => _components.add(component));
                            },
                            onRemoveComponent: (index) {
                              setState(() => _components.removeAt(index));
                            },
                          ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
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
      final body = {
        'name': _nameController.text,
        'unitId': _selectedUnitId,
        'stock': double.parse(_stockController.text),
        'costPerUnit': double.parse(_costPerUnitController.text),
        'minStock': double.parse(_minStockController.text),
        'isComposite': _isComposite,
      };

      if (_isComposite) {
        body['components'] = _components
            .map((c) => {
                  'componentIngredientId': c['componentIngredientId'],
                  'quantity': c['quantity'],
                  'unitId': c['unitId'],
                })
            .toList();
      }

      ref.read(ingredientNotifierProvider.notifier).addIngredient(body);
      Navigator.pop(context);
    }
  }
}
