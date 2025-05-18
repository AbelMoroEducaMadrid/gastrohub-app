import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
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
            '¡Casi lo tienes, $name!',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Revisa tu correo. Hemos enviado un enlace de verificación a ',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$email',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.hyperlinkColor,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Haz clic en él para activar tu cuenta.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 45),
          CustomButton(
            text: 'Volver al inicio de sesión',
            iconData: Icons.logout_outlined,
            iconPosition: IconPosition.right,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.backgroundColor,
          ),
        ],
      ),
    );
  }
}
