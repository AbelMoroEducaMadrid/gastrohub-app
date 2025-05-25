import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(title: const Text('Tables')),
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
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected Table ${table.number}')),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Table ${table.number}'),
                  Text('Capacity: ${table.capacity}'),
                  Text(table.state),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTable(context),
        child: const Icon(Icons.add),
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

  void _addTable(BuildContext context) {
    final numberController = TextEditingController();
    final capacityController = TextEditingController();
    final stateController = TextEditingController();
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
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: 'State'),
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
              final state = stateController.text.isEmpty
                  ? 'disponible'
                  : stateController.text;
              ref
                  .read(tableNotifierProvider(widget.layoutId).notifier)
                  .addTable(number, capacity, state);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
