import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gastrohub_app/src/core/utils/snackbar_utils.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/utils/dialog_utils.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/utils/form_validators.dart';
import 'package:gastrohub_app/src/core/widgets/forms/form_container.dart';

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
        if (authState.user!.restaurantId != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard',
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushReplacementNamed('/welcome');
        }
      } else if (authState.error != null) {
        DialogUtils.showErrorDialog(
          context: context,
          message: authState.error!,
          title: authState.errorTitle,
        ).then((_) {
          ref.read(authProvider.notifier).clearError();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final fillColor = Colors.grey.shade500.withAlpha((255 * 0.5).toInt());

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
                    SnackbarUtils.showAwesomeSnackbar(
                      context: context,
                      title: 'Atención',
                      message: 'Funcionalidad de recuperación no implementada',
                      contentType: ContentType.warning,
                    );
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
              onPressed: authState.isLoading ? null : _validateAndSubmit,
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
                SnackbarUtils.showAwesomeSnackbar(
                  context: context,
                  title: 'En desarrollo',
                  message: 'LogIn con Google no implementado aún',
                  contentType: ContentType.help,
                );
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
