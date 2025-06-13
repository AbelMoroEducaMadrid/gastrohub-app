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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: allergens.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allergens.length,
              itemBuilder: (context, index) {
                final allergen = allergens[index];
                return Card(
                  color: theme.cardColor,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      'assets/images/allergens/${allergen.name}.svg',
                      width: 50,
                      height: 50,
                      placeholderBuilder: (context) => Icon(
                        Icons.error,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    title: Text(
                      allergen.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      allergen.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
