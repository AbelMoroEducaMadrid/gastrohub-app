import 'package:flutter/material.dart';
import 'package:gastrohub_app/src/features/restaurant/models/table.dart';

class TablesGrid extends StatelessWidget {
  final List<RestaurantTable> tables;
  final Function(RestaurantTable) onTableTap;
  final double minCellWidth;
  final int maxColumns;

  const TablesGrid({
    super.key,
    required this.tables,
    required this.onTableTap,
    this.minCellWidth = 150.0,
    this.maxColumns = 5,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = tables.length < 4
        ? 2
        : (screenWidth / minCellWidth).floor().clamp(1, maxColumns);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return Card(
          color: _getStateColor(table.state),
          child: InkWell(
            onTap: () => onTableTap(table),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${table.number}',
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold)),
                Text('Capacidad: ${table.capacity}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'disponible':
        return Colors.green;
      case 'ocupada':
        return Colors.red;
      case 'reservada':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }
}
