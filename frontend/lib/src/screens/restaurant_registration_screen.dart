import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';
import 'package:gastrohub_app/src/core/widgets/form_container.dart';

// Asumimos que existe un provider para manejar el registro del restaurante
// final restaurantProvider = StateNotifierProvider<RestaurantNotifier, RestaurantState>((ref) => RestaurantNotifier());

class RestaurantRegistrationScreen extends ConsumerStatefulWidget {
  const RestaurantRegistrationScreen({super.key});

  @override
  ConsumerState<RestaurantRegistrationScreen> createState() =>
      _RestaurantRegistrationScreenState();
}

class _RestaurantRegistrationScreenState
    extends ConsumerState<RestaurantRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cuisineTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _registerRestaurant() async {
    if (_formKey.currentState!.validate()) {
      // Llamada al provider para registrar el restaurante (descomentar y ajustar según tu implementación)
      // await ref.read(restaurantProvider.notifier).registerRestaurant(
      //   name: nameController.text,
      //   address: addressController.text,
      //   cuisineType: cuisineTypeController.text,
      //   description: descriptionController.text,
      // );

      // Simulación de registro exitoso para navegación
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/dashboard');
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
    final theme = Theme.of(context);

    return FormContainer(
      backgroundImage: 'assets/images/background_01.png',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Registrar Restaurante',
              style: theme.textTheme.headlineLarge
                  ?.copyWith(color: AppTheme.primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: 'Nombre del Restaurante',
              controller: nameController,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Nombre del Restaurante'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Dirección',
              controller: addressController,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Dirección'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Tipo de Cocina',
              controller: cuisineTypeController,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Tipo de Cocina'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Descripción',
              controller: descriptionController,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Descripción'),
              minLines: 3,
              maxLines: 3,
              isTextArea: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Registrar Restaurante',
              onPressed: _registerRestaurant,
            ),
          ],
        ),
      ),
    );
  }
}
