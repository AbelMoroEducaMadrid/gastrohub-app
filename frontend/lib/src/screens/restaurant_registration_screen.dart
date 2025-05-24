import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/auth/models/payment_plan.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/auth/service/restaurant_service.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';
import 'package:gastrohub_app/src/core/widgets/form_container.dart';

class RestaurantRegistrationScreen extends ConsumerStatefulWidget {
  final PaymentPlan plan;

  const RestaurantRegistrationScreen({super.key, required this.plan});

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

  @override
  void initState() {
    super.initState();
    print('Plan recibido: ${widget.plan.name}, ID: ${widget.plan.id}');
  }

  void _registerRestaurant() async {
    print('Registrando restaurante con paymentPlanId: ${widget.plan.id}');
    if (_formKey.currentState!.validate()) {
      final restaurant = RestaurantRegistration(
        name: nameController.text,
        address: addressController.text,
        cuisineType: cuisineTypeController.text,
        description: descriptionController.text,
        paymentPlanId: widget.plan.id,
      );

      await ref.read(authProvider.notifier).registerRestaurant(restaurant);

      final authState = ref.read(authProvider);
      if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!)),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
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
