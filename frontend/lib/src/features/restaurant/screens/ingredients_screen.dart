import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/ingredient_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/add_ingredient_screen.dart';
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
    ref.read(ingredientNotifierProvider.notifier).loadIngredients();
    ref.read(unitNotifierProvider.notifier).loadUnits();
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(ingredientNotifierProvider);
    final units = ref.watch(unitNotifierProvider);

    return Scaffold(
      body: ingredients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                final unit = units.firstWhere(
                  (unit) => unit.id == ingredient.unitId,
                  orElse: () => Unit(id: 0, name: 'Desconocido', symbol: '?'),
                );
                return ListTile(
                  title: Text(ingredient.name),
                  subtitle: Text(
                    '${ingredient.stock.toStringAsFixed(2)} ${unit.symbol}',
                  ),
                );
              },
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
