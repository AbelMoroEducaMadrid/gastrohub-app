import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    OrdersTab(),
    TablesTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex)),
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
              // Navegar a la pantalla de perfil (placeholder)
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
              leading: const Icon(Icons.home),
              title: const Text('Home'),
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
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Mesas'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventario'),
              onTap: () {
                // Navegar a la pantalla de inventario
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Reservas'),
              onTap: () {
                // Navegar a la pantalla de reservas
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                // Navegar a la pantalla de configuración
                Navigator.pop(context);
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Mesas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                // Añadir nuevo pedido (placeholder)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Añadir nuevo pedido')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Pedidos';
      case 2:
        return 'Mesas';
      default:
        return 'Gastro & Hub';
    }
  }
}

// Pantallas placeholder
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bienvenido a Home', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Acción en Home')),
              );
            },
            child: const Text('Explorar'),
          ),
        ],
      ),
    );
  }
}

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Pedidos', style: TextStyle(fontSize: 24)),
    );
  }
}

class TablesTab extends StatelessWidget {
  const TablesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Mesas', style: TextStyle(fontSize: 24)),
    );
  }
}
