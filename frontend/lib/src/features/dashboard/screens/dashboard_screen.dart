import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/auth/screens/profile_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/layout_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/table_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/allergens_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/invitation_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/layouts_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/orders_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/products_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/work_tables_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/ingredients_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/employees_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  String _role = '';
  bool _isSpecialScreen = false;
  Widget? _specialScreen;

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
  }

  // Función para verificar permisos según el rol y la pantalla
  bool hasPermission(String role, String screen) {
    if (role == 'ROLE_ADMIN' || role == 'ROLE_SYSTEM') return true;
    switch (screen) {
      case 'Perfil':
      case 'Alérgenos':
      case 'Cerrar sesión':
        return true;
      case 'Productos':
      case 'Mesas':
      case 'Comandas':
        return role != 'ROLE_USER';
      case 'Zonas y mesas':
      case 'Ingredientes':
        return ['ROLE_OWNER', 'ROLE_MANAGER'].contains(role);
      case 'Empleados':
      case 'Código':
        return role == 'ROLE_OWNER';
      default:
        return false;
    }
  }

  // Botones inferiores según el rol
  List<BottomNavigationBarItem> _getBottomNavItems(String role) {
    if (role == 'ROLE_USER') {
      return [];
    }
    return [
      BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: 'Mesas'),
      BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), label: 'Comandas'),
      BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menú'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSpecialScreen = false;
      if (index == 0) {
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
      } else if (index == 1) {
        _specialScreen = const OrdersScreen();
        _isSpecialScreen = true;
      } else if (index == 2) {
        _specialScreen = const ProductsScreen();
        _isSpecialScreen = true;
      }
    });
  }

  Widget _getMainScreen(int index) {
    switch (index) {
      case 0:
        return WorkTablesScreen();
      case 1:
        return OrdersScreen();
      case 2:
        return ProductsScreen();
      default:
        return WorkTablesScreen();
    }
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
    final bottomNavItems = _getBottomNavItems(user.role);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSpecialScreen
            ? _specialScreenTitle()
            : _getTitle(_selectedIndex, user.role)),
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
              setState(() {
                _isSpecialScreen = true;
                _specialScreen = const ProfileScreen();
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gastro & Hub',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white, fontSize: 50),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.restaurantName!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                'Perfil',
                style: TextStyle(
                  color: hasPermission(_role, 'Perfil')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Perfil')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const ProfileScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(
                'Productos',
                style: TextStyle(
                  color: hasPermission(_role, 'Productos')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Productos')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const ProductsScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(
                'Mesas',
                style: TextStyle(
                  color: hasPermission(_role, 'Mesas')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Mesas')) {
                  _onItemTapped(0);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(
                'Comandas',
                style: TextStyle(
                  color: hasPermission(_role, 'Comandas')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Comandas')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const OrdersScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: Text(
                'Zonas y mesas',
                style: TextStyle(
                  color: hasPermission(_role, 'Zonas y mesas')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Zonas y mesas')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen =
                        LayoutsScreen(restaurantId: user.restaurantId!);
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: Text(
                'Ingredientes',
                style: TextStyle(
                  color: hasPermission(_role, 'Ingredientes')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Ingredientes')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const IngredientsScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: Text(
                'Empleados',
                style: TextStyle(
                  color: hasPermission(_role, 'Empleados')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Empleados')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const EmployeesScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: Text(
                'Código',
                style: TextStyle(
                  color: hasPermission(_role, 'Código')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Código')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const InvitationScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                'Alérgenos',
                style: TextStyle(
                  color: hasPermission(_role, 'Alérgenos')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Alérgenos')) {
                  setState(() {
                    _isSpecialScreen = true;
                    _specialScreen = const AllergensScreen();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'No tienes permisos para acceder a esta pantalla')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: hasPermission(_role, 'Cerrar sesión')
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              onTap: () {
                if (hasPermission(_role, 'Cerrar sesión')) {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No tienes permisos para cerrar sesión')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: _isSpecialScreen ? _specialScreen! : _getMainScreen(_selectedIndex),
      bottomNavigationBar: bottomNavItems.isNotEmpty
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
    if (role == 'ROLE_USER') return 'Gastro & Hub';
    switch (index) {
      case 0:
        return 'Mesas';
      case 1:
        return 'Comandas';
      case 2:
        return 'Menú';
      default:
        return 'Gastro & Hub';
    }
  }

  String _specialScreenTitle() {
    if (_specialScreen is OrdersScreen) return 'Comandas';
    if (_specialScreen is AllergensScreen) return 'Alérgenos';
    if (_specialScreen is IngredientsScreen) return 'Ingredientes';
    if (_specialScreen is ProfileScreen) return 'Perfil';
    if (_specialScreen is ProductsScreen) return 'Menú';
    if (_specialScreen is LayoutsScreen) return 'Zonas';
    if (_specialScreen is EmployeesScreen) return 'Empleados';
    if (_specialScreen is InvitationScreen) return 'Código de Invitación';
    return 'Gastro & Hub';
  }
}
