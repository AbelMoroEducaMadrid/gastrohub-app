import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const SizedBox.shrink();
    }

    final user = authState.user!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, ${user.name}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text('Email: ${user.email}'),
            Text('Teléfono: ${user.phone}'),
            Text('Rol: ${user.role}'),
            Text(
                'Restaurante: ${user.restaurantName} (ID: ${user.restaurantId})'),
            Text('Último login: ${user.lastLogin}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
