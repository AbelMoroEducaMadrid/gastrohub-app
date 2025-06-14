import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/exceptions/api_exception.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user!;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              Text('Rol: ${user.role}', style: const TextStyle(fontSize: 16)),
              Text('Restaurante: ${user.restaurantName ?? 'No asignado'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Guardar cambios'),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _leaveRestaurant,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Abandonar restaurante'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = ref.read(authServiceProvider);
      final token = ref.read(authProvider).token!;
      try {
        await authService.updateProfile(
          token,
          _nameController.text,
          _emailController.text,
          _phoneController.text,
        );
        final updatedUser = await authService.getUserData(token);
        ref.read(authProvider.notifier).updateUser(updatedUser);
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito')),
        );
      } catch (e) {
        if (e is ApiException) {
          AppLogger.error('Error al actualizar perfil: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        } else {
          AppLogger.error('Error inesperado: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error inesperado')),
          );
        }
      }
    }
  }

  void _leaveRestaurant() async {
    final authService = ref.read(authServiceProvider);
    final token = ref.read(authProvider).token!;
    try {
      await authService.leaveRestaurant(token);
      await ref.read(authProvider.notifier).logout();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      if (e is ApiException) {
        AppLogger.error('Error al abandonar restaurante: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      } else {
        AppLogger.error('Error inesperado: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error inesperado')),
        );
      }
    }
  }
}
