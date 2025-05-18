import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/utils/dialog_utils.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';
import 'package:gastrohub_app/src/core/widgets/form_container.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).login(
            emailController.text,
            passwordController.text,
          );

      if (!mounted) return;

      final authState = ref.read(authProvider);
      if (authState.user != null) {
        // Verifica si el usuario tiene un restaurante asignado
        if (authState.user!.restaurantId != null) {
          // Si tiene restaurante, va al dashboard
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else {
          // Si no tiene restaurante, va a la pantalla de bienvenida
          Navigator.of(context).pushReplacementNamed('/welcome');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final fillColor = Colors.grey.shade500.withAlpha((255 * 0.5).toInt());

    if (authState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DialogUtils.showErrorDialog(
          context: context,
          message: authState.error!,
          title: 'Error de inicio de sesión',
        );
      });
    }

    return FormContainer(
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
              label: 'Correo',
              controller: emailController,
              icon: Icons.email_outlined,
              fillColor: fillColor,
              validator: FormValidators.emailField,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Contraseña',
              obscureText: true,
              controller: passwordController,
              icon: Icons.key,
              fillColor: fillColor,
              validator: FormValidators.passwordField,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '¿Has olvidado tu contraseña? ',
                  style: theme.textTheme.labelMedium,
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Add password recovery logic
                  },
                  child: Text(
                    'Recuperar',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.hyperlinkColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Iniciar sesión',
              onPressed: _validateAndSubmit,
              iconData: Icons.login,
              iconPosition: IconPosition.right,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'O SI LO PREFIERES',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Iniciar sesión con Google',
              iconAssetPath: 'assets/images/google_logo.svg',
              isSvg: true,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: Colors.blueGrey,
              onPressed: () {
                // TODO: Add Google sign-in logic
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes cuenta? ',
                  style: theme.textTheme.labelMedium,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/register'),
                  child: Text(
                    'Regístrate gratis',
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
