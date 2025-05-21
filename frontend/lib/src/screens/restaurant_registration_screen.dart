import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = Colors.grey.shade500.withAlpha((255 * 0.5).toInt());

    return FormContainer(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppTheme.secondaryColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundImage: 'assets/images/background_01.png',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              height: 150,
              semanticsLabel: 'Logo de Gastro & Hub',
              colorFilter: ColorFilter.mode(
                AppTheme.secondaryColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'GASTRO & HUB',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 200,
                  color: AppTheme.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Datos del local',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: 'Nombre',
              controller: nameController,
              icon: Icons.restaurant_menu,
              fillColor: fillColor,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Nombre del Restaurante'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Dirección',
              controller: addressController,
              icon: Icons.location_on,
              fillColor: fillColor,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Dirección'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Tipo de Cocina',
              controller: cuisineTypeController,
              icon: Icons.restaurant,
              fillColor: fillColor,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Tipo de Cocina'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Descripción',
              controller: descriptionController,  
              fillColor: fillColor,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Descripción'),
              minLines: 3,
              maxLines: 3,
              isTextArea: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Continuar',
              onPressed: _registerRestaurant,
              iconData: Icons.navigate_next_outlined,
              iconPosition: IconPosition.right,
            ),
          ],
        ),
      ),
    );
  }
}
