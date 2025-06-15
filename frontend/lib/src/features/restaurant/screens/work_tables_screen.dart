import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/grids/tables_grid.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/layout_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_provider.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/table_orders_screen.dart';

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
      body: TablesGrid(
        tables: tables,
        onTableTap: (table) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TableOrdersScreen(
                tableId: table.id,
                layoutId: table.layoutId,
                tableNumber: table.number,
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
