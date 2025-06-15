import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
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

  void _confirmDelete(BuildContext context, int layoutId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación',
            style: TextStyle(color: Colors.black)),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este layout?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(layoutNotifierProvider(widget.restaurantId).notifier)
                  .deleteLayout(layoutId);
              Navigator.pop(context);
            },
            child: Text(
              'Si',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layouts = ref.watch(layoutNotifierProvider(widget.restaurantId));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: layouts.length,
          itemBuilder: (context, index) {
            final layout = layouts[index];
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
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TablesScreen(layoutId: layout.id),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              layout.name.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _editLayout(context, layout),
                      child: Container(
                        width: 50,
                        color: Colors.blue,
                        child: const Center(
                          child: Icon(Icons.edit_outlined,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _confirmDelete(context, layout.id),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Container(
                          width: 50,
                          color: Colors.red,
                          child: const Center(
                            child: Icon(Icons.delete_outline,
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
        title:
            const Text('Agregar Layout', style: TextStyle(color: Colors.black)),
        content: CustomTextField(
          label: 'Nombre',
          controller: nameController,
          icon: Icons.map,
          textColor: Colors.black,
          borderColor: Colors.black,
          cursorColor: Colors.black,
          placeholderColor: Colors.black,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(layoutNotifierProvider(widget.restaurantId).notifier)
                  .addLayout(nameController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Agregar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
        title:
            const Text('Editar Layout', style: TextStyle(color: Colors.black)),
        content: CustomTextField(
          label: 'Nombre',
          controller: nameController,
          icon: Icons.map,
          textColor: Colors.black,
          borderColor: Colors.black,
          cursorColor: Colors.black,
          placeholderColor: Colors.black,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(layoutNotifierProvider(widget.restaurantId).notifier)
                  .updateLayout(layout.id, nameController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Guardar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
