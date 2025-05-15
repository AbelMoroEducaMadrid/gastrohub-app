import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            emailController.text,
            passwordController.text,
          );
    }
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth =
                    constraints.maxWidth > 400 ? 400.0 : constraints.maxWidth;
                return SizedBox(
                  width: maxWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                          semanticLabel: 'Logo de Gastro & Hub',
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'GASTRO & HUB',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Correo Electrónico',
                          controller: emailController,
                          validator: FormValidators.emailField,
                          onChanged: (_) => _formKey.currentState?.validate(),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Contraseña',
                          obscureText: true,
                          controller: passwordController,
                          validator: FormValidators.passwordField,
                          onChanged: (_) => _formKey.currentState?.validate(),
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
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Iniciar sesión',
                          onPressed: _validateAndSubmit,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'o si lo prefieres',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Iniciar sesión con Google',
                          iconAssetPath: 'assets/images/google_logo.svg',
                          isSvg: true,
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: AppTheme.textColor,
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
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/register'),
                              child: Text(
                                'Regístrate gratis',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (authState.isLoading)
                          const Center(child: CircularProgressIndicator()),
                        if (authState.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              authState.error!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (authState.user != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Bienvenido, ${authState.user!.name}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.successColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
