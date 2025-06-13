import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/allergen_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllergensScreen extends ConsumerStatefulWidget {
  const AllergensScreen({super.key});

  @override
  ConsumerState<AllergensScreen> createState() => _AllergensScreenState();
}

class _AllergensScreenState extends ConsumerState<AllergensScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(allergenNotifierProvider.notifier).loadAllergens();
  }

  @override
  Widget build(BuildContext context) {
    final allergens = ref.watch(allergenNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alérgenos')),
      body: allergens.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allergens.length,
              itemBuilder: (context, index) {
                final allergen = allergens[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      'assets/images/allergens/${allergen.name}.svg',
                      width: 50,
                      height: 50,
                      placeholderBuilder: (context) => const Icon(Icons.error),
                    ),
                    title: Text(allergen.name),
                    subtitle: Text(allergen.description),
                  ),
                );
              },
            ),
    );
  }
}