import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/add_ingredient_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/edit_ingredient_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/unit_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/models/unit.dart';

class IngredientsScreen extends ConsumerStatefulWidget {
  const IngredientsScreen({super.key});

  @override
  ConsumerState<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends ConsumerState<IngredientsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ingredientNotifierProvider.notifier).loadIngredients();
      ref.read(unitNotifierProvider.notifier).loadUnits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientNotifierProvider);
    final units = ref.watch(unitNotifierProvider);

    return Scaffold(
      body: ingredientsAsync.when(
        data: (ingredients) => ingredients.isEmpty
            ? const Center(child: Text('No hay ingredientes disponibles'))
            : ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  final unit = units.firstWhere(
                    (unit) => unit.id == ingredient.unitId,
                    orElse: () => Unit(id: 0, name: 'Desconocido', symbol: '?'),
                  );
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ingredient.name,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Row(
                            children: ingredient.attributes.map((attr) {
                              final iconPath =
                                  'assets/images/allergens/$attr.svg';
                              return Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: SvgPicture.asset(
                                  iconPath,
                                  width: 24,
                                  height: 24,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Stock: ${ingredient.stock.toStringAsFixed(2)} ${unit.symbol}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditIngredientScreen(ingredient: ingredient),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addIngredient(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addIngredient(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddIngredientScreen()),
    );
  }
}
