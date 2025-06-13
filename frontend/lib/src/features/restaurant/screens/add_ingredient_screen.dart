import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/unit_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/models/ingredient.dart';

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
  List<Map<String, dynamic>> _components = [];

  @override
  void initState() {
    super.initState();
    ref.read(ingredientNotifierProvider.notifier).loadNonCompositeIngredients();
    ref.read(unitNotifierProvider.notifier).loadUnits();
  }

  @override
  Widget build(BuildContext context) {
    final units = ref.watch(unitNotifierProvider);
    final nonCompositeIngredients = ref.watch(nonCompositeIngredientsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Fondo del tema
      appBar: AppBar(
        title: Text(
          'Añadir Ingrediente',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            DropdownButtonFormField<int>(
              value: _selectedUnitId,
              decoration: InputDecoration(
                labelText: 'Unidad',
                labelStyle: TextStyle(color: Colors.black),
              ),
              items: units.map((unit) {
                return DropdownMenuItem<int>(
                  value: unit.id,
                  child: Text(
                    unit.name,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedUnitId = value),
              validator: (value) => value == null ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Stock',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _costPerUnitController,
              decoration: InputDecoration(
                labelText: 'Coste por unidad',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _minStockController,
              decoration: InputDecoration(
                labelText: 'Stock mínimo',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            SwitchListTile(
              title: Text(
                'Es compuesto',
                style: TextStyle(color: Colors.black),
              ),
              value: _isComposite,
              onChanged: (value) => setState(() => _isComposite = value),
            ),
            if (_isComposite)
              Column(
                children: [
                  Text(
                    'Componentes:',
                    style: TextStyle(color: Colors.black),
                  ),
                  ..._components.map((component) {
                    return ListTile(
                      title: Text(
                        component['name'],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Cantidad: ${component['quantity']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _components.remove(component);
                          });
                        },
                      ),
                    );
                  }).toList(),
                  ElevatedButton(
                    onPressed: () => _addComponent(nonCompositeIngredients),
                    child: Text(
                      'Añadir componente',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                'Guardar',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addComponent(List<Ingredient> nonCompositeIngredients) {
    showDialog(
      context: context,
      builder: (context) {
        Ingredient? selectedIngredient;
        final quantityController = TextEditingController();

        return AlertDialog(
          title: Text(
            'Añadir componente',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Ingredient>(
                decoration: InputDecoration(
                  labelText: 'Ingrediente',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                items: nonCompositeIngredients.map((ingredient) {
                  return DropdownMenuItem<Ingredient>(
                    value: ingredient,
                    child: Text(
                      ingredient.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) => selectedIngredient = value,
              ),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedIngredient != null &&
                    quantityController.text.isNotEmpty) {
                  setState(() {
                    _components.add({
                      'componentIngredientId': selectedIngredient!.id,
                      'name': selectedIngredient!.name,
                      'quantity': double.parse(quantityController.text),
                      'unitId': selectedIngredient!.unitId,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Añadir',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
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
