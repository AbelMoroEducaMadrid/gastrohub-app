import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/layout_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_provider.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class WorkTablesScreen extends ConsumerStatefulWidget {
  const WorkTablesScreen({super.key});

  @override
  ConsumerState<WorkTablesScreen> createState() => _WorkTablesScreenState();
}

class _WorkTablesScreenState extends ConsumerState<WorkTablesScreen> {
  @override
  void initState() {
    super.initState();
    final restaurantId = ref.read(authProvider).user!.restaurantId!;
    ref.read(layoutNotifierProvider(restaurantId).notifier).loadLayouts();
    final layouts = ref.read(layoutNotifierProvider(restaurantId));
    if (ref.read(activeLayoutProvider) == null && layouts.isNotEmpty) {
      Future.microtask(() {
        ref.read(activeLayoutProvider.notifier).state = layouts.first.id;
      });
    }
    final initialLayoutId = ref.read(activeLayoutProvider);
    if (initialLayoutId != null) {
      ref.read(tableNotifierProvider(initialLayoutId).notifier).loadTables();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(activeLayoutProvider, (previous, next) {
      if (next != null && next != previous) {
        ref.read(tableNotifierProvider(next).notifier).loadTables();
      }
    });

    final layoutId = ref.watch(activeLayoutProvider);
    final restaurantId = ref.watch(authProvider).user!.restaurantId!;

    if (layoutId == null) {
      return const Center(child: Text('No hay layouts disponibles'));
    }

    final tables = ref.watch(tableNotifierProvider(layoutId));

    return Scaffold(
      appBar: AppBar(title: const Text('Mesas en Servicio')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          final table = tables[index];
          return Card(
            color: _getStateColor(table.state),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mesa ${table.number} seleccionada')),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Mesa ${table.number}'),
                  Text('Capacidad: ${table.capacity}'),
                  Text(table.state),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectLayout(context, restaurantId),
        child: const Icon(Icons.map),
      ),
    );
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'disponible':
        return Colors.green[100]!;
      case 'ocupada':
        return Colors.red[100]!;
      case 'reservada':
        return Colors.yellow[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  void _selectLayout(BuildContext context, int restaurantId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final layouts = ref.watch(layoutNotifierProvider(restaurantId));
        return ListView.builder(
          itemCount: layouts.length,
          itemBuilder: (context, index) {
            final layout = layouts[index];
            return ListTile(
              title: Text(layout.name),
              onTap: () {
                ref.read(activeLayoutProvider.notifier).state = layout.id;
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
