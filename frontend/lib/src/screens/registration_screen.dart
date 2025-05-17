import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _confirmPasswordValidator(String? value) {
    if (value != passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void _register() async {
    ref.read(authProvider.notifier).logout();

    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).register(
            nameController.text,
            emailController.text,
            passwordController.text,
            phoneController.text,
          );

      if (!mounted) return;

      final authState = ref.read(authProvider);
      if (authState.registrationSuccess) {
        Navigator.of(context).pushReplacementNamed('/login');
        ref.read(authProvider.notifier).resetRegistration();
      } else if (authState.error != null) {
        _showErrorDialog(authState.error!);
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error de registro'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Registrarse',
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: AppTheme.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Nombre',
                    controller: nameController,
                    validator: (value) =>
                        FormValidators.requiredField(value, 'Nombre'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Apellidos',
                    controller: lastNameController,
                    validator: (value) =>
                        FormValidators.requiredField(value, 'Apellidos'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Correo Electrónico',
                    controller: emailController,
                    validator: FormValidators.emailField,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Teléfono',
                    controller: phoneController,
                    validator: FormValidators.phoneField,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Contraseña',
                    obscureText: true,
                    controller: passwordController,
                    validator: FormValidators.passwordField,
                    onChanged: (_) => _formKey.currentState?.validate(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Confirmar contraseña',
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: _confirmPasswordValidator,
                    onChanged: (_) => _formKey.currentState?.validate(),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Registrarse',
                    onPressed: _register,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿Ya tienes cuenta? ',
                          style: theme.textTheme.labelMedium),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('/login'),
                        child: Text(
                          'Inicia sesión',
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  if (authState.isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
