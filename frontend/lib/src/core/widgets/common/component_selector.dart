import 'package:flutter/material.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/features/restaurant/models/ingredient.dart';

class ComponentSelector extends StatefulWidget {
  final List<Map<String, dynamic>> components;
  final List<Ingredient> nonCompositeIngredients;
  final Function(Map<String, Object>) onAddComponent;
  final Function(int) onRemoveComponent;

  const ComponentSelector({
    super.key,
    required this.components,
    required this.nonCompositeIngredients,
    required this.onAddComponent,
    required this.onRemoveComponent,
  });

  @override
  _ComponentSelectorState createState() => _ComponentSelectorState();
}

class _ComponentSelectorState extends State<ComponentSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Componentes:',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        ...widget.components.asMap().entries.map((entry) {
          final index = entry.key;
          final component = entry.value;
          return ListTile(
            title: Text(component['name'],
                style: const TextStyle(color: Colors.black)),
            subtitle: Text('Cantidad: ${component['quantity']}',
                style: const TextStyle(color: Colors.black)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: () => widget.onRemoveComponent(index),
            ),
          );
        }),
        ElevatedButton(
          onPressed: _showAddComponentDialog,
          child: const Text('Añadir componente'),
        ),
      ],
    );
  }

  void _showAddComponentDialog() {
    Ingredient? selectedIngredient;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Añadir componente',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.nonCompositeIngredients.isEmpty
                  ? const Text(
                      'No hay ingredientes disponibles',
                      style: TextStyle(color: Colors.black),
                    )
                  : DropdownButtonFormField<Ingredient>(
                      decoration: InputDecoration(
                        labelText: 'Ingrediente',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      dropdownColor: Colors.white,
                      items: widget.nonCompositeIngredients.map((ingredient) {
                        return DropdownMenuItem<Ingredient>(
                          value: ingredient,
                          child: Text(
                            ingredient.name,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => selectedIngredient = value,
                    ),
              CustomTextField(
                label: 'Cantidad',
                controller: quantityController,
                keyboardType: TextInputType.number,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                placeholderColor: Colors.black54,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedIngredient != null &&
                    quantityController.text.isNotEmpty) {
                  widget.onAddComponent(<String, Object>{
                    'componentIngredientId': selectedIngredient!.id,
                    'name': selectedIngredient!.name,
                    'quantity': double.parse(quantityController.text),
                    'unitId': selectedIngredient!.unitId,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Añadir',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
