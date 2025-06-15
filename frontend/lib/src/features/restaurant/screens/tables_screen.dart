import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/models/table.dart';
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

  void _editTable(BuildContext context, RestaurantTable table) {
    final numberController =
        TextEditingController(text: table.number.toString());
    final capacityController =
        TextEditingController(text: table.capacity.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Mesa', style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Número',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacidad',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              final number = int.tryParse(numberController.text) ?? 0;
              final capacity = int.tryParse(capacityController.text) ?? 0;
              if (number <= 0 || capacity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Número y capacidad deben ser mayores a 0',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
                return;
              }
              ref
                  .read(tableNotifierProvider(widget.layoutId).notifier)
                  .updateTable(
                    table.id,
                    RestaurantTable(
                      id: table.id,
                      layoutId: table.layoutId,
                      number: number,
                      capacity: capacity,
                      state: table.state,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tables = ref.watch(tableNotifierProvider(widget.layoutId));

    return Scaffold(
      appBar: AppBar(
          title: const Text('Mesas', style: TextStyle(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, index) {
            final table = tables[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mesa ${table.number}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text('Capacidad: ${table.capacity}',
                                style: const TextStyle(color: Colors.black)),
                            Text('Estado: ${table.state}',
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _editTable(context, table),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Container(
                          width: 50,
                          color: Colors.blue,
                          child: const Center(
                            child: Icon(Icons.edit_outlined,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
        title:
            const Text('Agregar Mesa', style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Número',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacidad',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              final number = int.tryParse(numberController.text) ?? 0;
              final capacity = int.tryParse(capacityController.text) ?? 0;
              if (number <= 0 || capacity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Número y capacidad deben ser mayores a 0',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
                return;
              }
              ref
                  .read(tableNotifierProvider(widget.layoutId).notifier)
                  .addTable(number, capacity);
              Navigator.pop(context);
            },
            child: const Text('Agregar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
