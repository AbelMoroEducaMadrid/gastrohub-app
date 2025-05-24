import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';
import 'package:gastrohub_app/src/core/widgets/form_container.dart';
import 'package:gastrohub_app/src/core/utils/dialog_utils.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
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

  void _showErrorDialog(String message, {String? title}) {
    DialogUtils.showErrorDialog(
      context: context,
      message: message,
      title: title,
    );
  }

  void _register() async {
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
        Navigator.of(context).pushReplacementNamed('/verification-pending',
            arguments: {
              'email': emailController.text,
              'name': nameController.text
            });
        ref.read(authProvider.notifier).resetRegistration();
      } else if (authState.error != null) {
        _showErrorDialog(authState.error!, title: authState.errorTitle);
        ref.read(authProvider.notifier).clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
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
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nombre',
              controller: nameController,
              icon: Icons.person_outline,
              fillColor: fillColor,
              validator: (value) =>
                  FormValidators.requiredField(value, 'Nombre'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Correo Electrónico',
              controller: emailController,
              icon: Icons.email_outlined,
              fillColor: fillColor,
              keyboardType: TextInputType.emailAddress,
              validator: FormValidators.emailField,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Teléfono',
              controller: phoneController,
              icon: Icons.phone_outlined,
              fillColor: fillColor,
              keyboardType: TextInputType.phone,
              validator: FormValidators.phoneField,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Contraseña',
              obscureText: true,
              controller: passwordController,
              icon: Icons.key,
              fillColor: fillColor,
              keyboardType: TextInputType.visiblePassword,
              validator: FormValidators.passwordField,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirmar contraseña',
              obscureText: true,
              controller: confirmPasswordController,
              icon: Icons.key,
              fillColor: fillColor,
              keyboardType: TextInputType.visiblePassword,
              validator: _confirmPasswordValidator,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Registrarse',
              onPressed: authState.isLoading ? null : _register,
              iconData: Icons.app_registration,
              iconPosition: IconPosition.right,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿Ya tienes cuenta? ', style: theme.textTheme.labelMedium),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed('/login'),
                  child: Text(
                    'Inicia sesión',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.hyperlinkColor,
                    ),
                  ),
                ),
              ],
            ),
            if (authState.isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
