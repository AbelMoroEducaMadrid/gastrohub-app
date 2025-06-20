import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/core/utils/logger.dart';
import 'package:gastrohub_app/src/core/utils/snackbar_utils.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
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
  late TextEditingController _roleController;
  late TextEditingController _restaurantController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user!;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _roleController = TextEditingController(text: user.role);
    _restaurantController =
        TextEditingController(text: user.restaurantName ?? 'No asignado');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'Nombre',
                controller: _nameController,
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                placeholderColor: Colors.black54,
                icon: Icons.person_outline,
              ),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                placeholderColor: Colors.black54,
                icon: Icons.email_outlined,
              ),
              CustomTextField(
                label: 'Teléfono',
                controller: _phoneController,
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                placeholderColor: Colors.black54,
                icon: Icons.phone_outlined,
              ),
              ..._isEditing
                  ? [
                      const SizedBox(height: 16),
                      CustomButton(
                        onPressed: _updateProfile,
                        text: 'Guardar cambios',
                        iconData: Icons.save_outlined,
                        iconPosition: IconPosition.right,
                      ),
                      const SizedBox(height: 16),
                    ]
                  : [],
              CustomTextField(
                label: 'Rol',
                controller: _roleController,
                enabled: false,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                placeholderColor: Colors.black54,
                icon: Icons.badge_outlined,
              ),
              CustomTextField(
                label: 'Restaurante',
                controller: _restaurantController,
                enabled: false,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                placeholderColor: Colors.black54,
                icon: Icons.restaurant_outlined,
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _leaveRestaurant,
                text: 'Abandonar restaurante',
                iconData: Icons.exit_to_app_outlined,
                iconPosition: IconPosition.right,
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _logout,
                text: 'Cerrar sesión',
                iconData: Icons.logout_outlined,
                iconPosition: IconPosition.right,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        child: Icon(_isEditing ? Icons.close : Icons.edit),
      ),
    );
  }

  void _logout() async {
    ref.read(authProvider.notifier).logout();
    Navigator.of(context).pushReplacementNamed('/login');
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
        SnackbarUtils.showAwesomeSnackbar(
          context: context,
          title: 'Éxito',
          message: 'Perfil actualizado con éxito',
          contentType: ContentType.success,
        );
      } catch (e) {
        if (e is ApiException) {
          AppLogger.error('Error al actualizar perfil: ${e.message}');
          SnackbarUtils.showAwesomeSnackbar(
            context: context,
            title: 'Error',
            message: 'Error: ${e.message}',
            contentType: ContentType.failure,
          );
        } else {
          AppLogger.error('Error inesperado: $e');
          SnackbarUtils.showAwesomeSnackbar(
            context: context,
            title: 'Error',
            message: 'Error inesperado',
            contentType: ContentType.failure,
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
        SnackbarUtils.showAwesomeSnackbar(
          context: context,
          title: 'Error',
          message: 'Error: ${e.message}',
          contentType: ContentType.failure,
        );
      } else {
        AppLogger.error('Error inesperado: $e');
        SnackbarUtils.showAwesomeSnackbar(
          context: context,
          title: 'Error',
          message: 'Error inesperado',
          contentType: ContentType.failure,
        );
      }
    }
  }
}
