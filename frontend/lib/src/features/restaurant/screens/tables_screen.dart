import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/grids/tables_grid.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_provider.dart';

class TablesScreen extends ConsumerStatefulWidget {
  final int layoutId;

  const TablesScreen({super.key, required this.layoutId});

  @override
  ConsumerState<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends ConsumerState<TablesScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(tableNotifierProvider(widget.layoutId).notifier).loadTables();
  }

  @override
  Widget build(BuildContext context) {
    final tables = ref.watch(tableNotifierProvider(widget.layoutId));

    return Scaffold(
      appBar: AppBar(title: const Text('Mesas')),
      body: TablesGrid(
        tables: tables,
        onTableTap: (table) {
          // TODO: Verificar si hay comanda activa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Editar mesa ${table.number} (admin)')),
          );
          // Lógica futura: if (hasActiveOrder) { showOrder(); } else { editTable(); }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTable(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTable(BuildContext context) {
    final numberController = TextEditingController();
    final capacityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final number = int.tryParse(numberController.text) ?? 0;
              final capacity = int.tryParse(capacityController.text) ?? 0;
              if (number <= 0 || capacity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Número y capacidad deben ser mayores a 0')),
                );
                return;
              }
              ref
                  .read(tableNotifierProvider(widget.layoutId).notifier)
                  .addTable(number, capacity);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
