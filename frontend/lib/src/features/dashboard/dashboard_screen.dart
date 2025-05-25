import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/layout_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/layouts_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/work_tables_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  String _role = '';

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    if (authState.user != null) {
      _role = authState.user!.role;
      _loadInitialData(authState.user!.restaurantId!, _role);
    }
  }

  void _loadInitialData(int restaurantId, String role) {
    ref.read(layoutNotifierProvider(restaurantId).notifier).loadLayouts();
    // Aquí cargar datos según el rol
  }

  List<Widget> _getWidgetOptions(String role, int restaurantId) {
    switch (role) {
      case 'ROLE_OWNER':
        return [
          WorkTablesScreen(),
          OrdersTab(),
          EditMenusScreen(restaurantId: restaurantId),
        ];
      case 'ROLE_MANAGER':
        return [
          WorkTablesScreen(),
          OrdersTab(),
          EditMenusScreen(restaurantId: restaurantId),
        ];
      case 'ROLE_WAITER':
        return [
          WorkTablesScreen(),
          OrdersTab(),
          WorkMenusScreen(restaurantId: restaurantId),
        ];
      case 'ROLE_COOK':
        return [OrdersTab()];
      default:
        return [WorkTablesScreen()];
    }
  }

  List<BottomNavigationBarItem> _getBottomNavItems(String role) {
    switch (role) {
      case 'ROLE_OWNER':
        return [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: 'Mesas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menús'),
        ];
      case 'ROLE_MANAGER':
        return [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: 'Mesas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menús'),
        ];
      case 'ROLE_WAITER':
        return [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: 'Mesas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menús'),
        ];
      case 'ROLE_COOK':
        return [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Comandas'),
        ];
      default:
        return [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: 'Mesas'),
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0 && _role != 'ROLE_COOK') {
        final restaurantId = ref.read(authProvider).user!.restaurantId!;
        ref.read(layoutNotifierProvider(restaurantId).notifier).loadLayouts();
        final layouts = ref.read(layoutNotifierProvider(restaurantId));
        final currentLayoutId = ref.read(activeLayoutProvider);
        if (currentLayoutId == null && layouts.isNotEmpty) {
          Future.microtask(() {
            ref.read(activeLayoutProvider.notifier).state = layouts.first.id;
          });
        }
        final layoutId = ref.read(activeLayoutProvider) ?? layouts.first.id;
        ref.read(tableNotifierProvider(layoutId).notifier).loadTables();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const SizedBox.shrink();
    }

    final user = authState.user!;
    final widgetOptions = _getWidgetOptions(user.role, user.restaurantId!);
    final bottomNavItems = _getBottomNavItems(user.role);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex, user.role)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navegar a la pantalla de perfil
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gastro & Hub',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white70),
                  ),
                  Text(
                    user.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Menús'),
              onTap: () {
                Navigator.pop(context);
                if (user.role == 'ROLE_OWNER' || user.role == 'ROLE_MANAGER') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditMenusScreen(restaurantId: user.restaurantId!),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkMenusScreen(restaurantId: user.restaurantId!),
                    ),
                  );
                }
              },
              enabled: user.role != 'ROLE_COOK',
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Mesas'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Pedidos'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            if (user.role == 'ROLE_OWNER' || user.role == 'ROLE_MANAGER')
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Zonas y mesas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LayoutsScreen(restaurantId: user.restaurantId!),
                    ),
                  );
                },
              ),
            if (user.role == 'ROLE_OWNER' || user.role == 'ROLE_MANAGER')
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Inventario'),
                onTap: () {
                  Navigator.pop(context);
                  // Navegar a Inventario
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: bottomNavItems.length >= 2
          ? BottomNavigationBar(
              items: bottomNavItems,
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _onItemTapped,
            )
          : null,
    );
  }

  String _getTitle(int index, String role) {
    switch (role) {
      case 'ROLE_OWNER':
        return ['Mesas', 'Pedidos', 'Menús'][index];
      case 'ROLE_MANAGER':
        return ['Mesas', 'Pedidos', 'Menús'][index];
      case 'ROLE_WAITER':
        return ['Mesas', 'Pedidos', 'Menús'][index];
      case 'ROLE_COOK':
        return ['Comandas'][index];
      default:
        return 'Gastro & Hub';
    }
  }
}

// Pantallas placeholder existentes
class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Pantalla de Pedidos'));
  }
}

class EditMenusScreen extends StatelessWidget {
  final int restaurantId;
  const EditMenusScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Editar Menús - Restaurante: $restaurantId'),
    );
  }
}

class WorkMenusScreen extends StatelessWidget {
  final int restaurantId;
  const WorkMenusScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Menús de Trabajo - Restaurante: $restaurantId'),
    );
  }
}
