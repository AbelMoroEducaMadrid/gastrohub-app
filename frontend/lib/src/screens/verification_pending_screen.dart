import 'package:flutter/material.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/form_container.dart';

class VerificationPendingScreen extends StatelessWidget {
  final String name;
  final String email;

  const VerificationPendingScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormContainer(
      backgroundImage: 'assets/images/background_01.png',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 150,
            semanticLabel: 'Logo de Gastro & Hub',
          ),
          const SizedBox(height: 24),
          Text(
            '¡Casi lo tienes, $name!',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Hemos enviado un enlace de verificación a $email. '
            'Haz clic en él para activar tu cuenta.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text(
              'Volver al inicio de sesión',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
