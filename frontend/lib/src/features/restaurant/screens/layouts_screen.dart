import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/models/layout.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/layout_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/tables_screen.dart';

class LayoutsScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const LayoutsScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<LayoutsScreen> createState() => _LayoutsScreenState();
}

class _LayoutsScreenState extends ConsumerState<LayoutsScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(layoutNotifierProvider(widget.restaurantId).notifier)
        .loadLayouts();
  }

  @override
  Widget build(BuildContext context) {
    final layouts = ref.watch(layoutNotifierProvider(widget.restaurantId));

    return Scaffold(
      appBar: AppBar(title: const Text('Layouts')),
      body: ListView.builder(
        itemCount: layouts.length,
        itemBuilder: (context, index) {
          final layout = layouts[index];
          return ListTile(
            title: Text(layout.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editLayout(context, layout),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => ref
                      .read(
                          layoutNotifierProvider(widget.restaurantId).notifier)
                      .deleteLayout(layout.id),
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TablesScreen(layoutId: layout.id)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addLayout(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addLayout(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Layout'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(layoutNotifierProvider(widget.restaurantId).notifier)
                  .addLayout(nameController.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editLayout(BuildContext context, Layout layout) {
    final nameController = TextEditingController(text: layout.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Layout'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(layoutNotifierProvider(widget.restaurantId).notifier)
                  .updateLayout(layout.id, nameController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
