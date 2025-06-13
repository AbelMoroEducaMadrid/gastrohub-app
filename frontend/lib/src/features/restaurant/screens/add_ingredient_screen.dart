import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/unit_provider.dart';

class AddIngredientScreen extends ConsumerStatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  ConsumerState<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends ConsumerState<AddIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _costPerUnitController = TextEditingController();
  final _minStockController = TextEditingController();
  int? _selectedUnitId;
  bool _isComposite = false;

  @override
  Widget build(BuildContext context) {
    final units = ref.watch(unitNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Ingrediente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            DropdownButtonFormField<int>(
              value: _selectedUnitId,
              decoration: const InputDecoration(labelText: 'Unidad'),
              items: units.map((unit) {
                return DropdownMenuItem<int>(
                  value: unit.id,
                  child: Text(unit.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedUnitId = value),
              validator: (value) => value == null ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _costPerUnitController,
              decoration: const InputDecoration(labelText: 'Coste por unidad'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _minStockController,
              decoration: const InputDecoration(labelText: 'Stock mínimo'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            SwitchListTile(
              title: const Text('Es compuesto'),
              value: _isComposite,
              onChanged: (value) => setState(() => _isComposite = value),
            ),
            if (_isComposite)
              const Text('Selector de componentes (pendiente)'),
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
        'components': [],
      };
      ref.read(ingredientNotifierProvider.notifier).addIngredient(body);
      Navigator.pop(context);
    }
  }
}