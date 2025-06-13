import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/component_selector.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_dropdown_field.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/features/restaurant/models/ingredient.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/unit_provider.dart';

class EditIngredientScreen extends ConsumerStatefulWidget {
  final Ingredient ingredient;

  const EditIngredientScreen({super.key, required this.ingredient});

  @override
  ConsumerState<EditIngredientScreen> createState() =>
      _EditIngredientScreenState();
}

class _EditIngredientScreenState extends ConsumerState<EditIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _costPerUnitController;
  late TextEditingController _minStockController;
  int? _selectedUnitId;
  bool _isComposite = false;
  List<Map<String, Object>> _components = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ingredient.name);
    _stockController =
        TextEditingController(text: widget.ingredient.stock.toString());
    _costPerUnitController =
        TextEditingController(text: widget.ingredient.costPerUnit.toString());
    _minStockController =
        TextEditingController(text: widget.ingredient.minStock.toString());
    _selectedUnitId = widget.ingredient.unitId;
    _isComposite = widget.ingredient.isComposite;
    if (_isComposite) {
      _components = widget.ingredient.components
              ?.map((c) => <String, Object>{
                    'componentIngredientId': c.componentIngredientId,
                    'name': c.componentName,
                    'quantity': c.quantity,
                    'unitId': c.unitId,
                  })
              .toList() ??
          [];
    }
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
      appBar: AppBar(title: const Text('Editar ingrediente')),
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
      final body = <String, Object>{
        'name': _nameController.text,
        'unitId': _selectedUnitId as Object,
        'stock': double.parse(_stockController.text),
        'costPerUnit': double.parse(_costPerUnitController.text),
        'minStock': double.parse(_minStockController.text),
        'isComposite': _isComposite,
      };

      if (_isComposite) {
        body['components'] = _components
            .map((c) => <String, Object>{
                  'componentIngredientId': c['componentIngredientId'] as Object,
                  'quantity': c['quantity'] as Object,
                  'unitId': c['unitId'] as Object,
                })
            .toList();
      }

      ref
          .read(ingredientNotifierProvider.notifier)
          .updateIngredient(widget.ingredient.id, body);
      Navigator.pop(context);
    }
  }
}
