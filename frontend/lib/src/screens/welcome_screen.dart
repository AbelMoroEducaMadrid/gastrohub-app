import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/form_container.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isJoining = false;

  void _createRestaurant() {
    // TODO: Navega a la pantalla de creación de restaurante (a implementar)
    // Navigator.of(context).pushNamed('/create-restaurant');
  }

  void _joinRestaurant() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isJoining = true);
      final code = codeController.text;
      try {
        // Espera a que se complete la llamada asincrónica
        await ref.read(authProvider.notifier).joinRestaurant(code);

        if (!mounted) return;

        final authState = ref.read(authProvider);
        if (authState.error != null) {
          _showErrorDialog(authState.error!);
        } else {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() => isJoining = false);
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error al unirse al restaurante'),
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
    final user = authState.user;

    // Si no hay usuario, redirigir al login
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return FormContainer(
      backgroundImage: 'assets/images/background_01.png',
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
                fontSize: 200,
                color: AppTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bienvenido, ${user.name}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '¿Eres dueño de un establecimiento?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Configurar',
            onPressed: _createRestaurant,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '¿ERES EMPLEADO?',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: CustomTextField(
              label: 'Código del establecimiento',
              controller: codeController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            const Text('¿Qué es el código de establecimiento?'),
                        content: const Text(
                          'Es un código único que te permite unirte a un restaurante específico. Pídelo a tu gerente o dueño.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  '¿Qué es esto? ',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isJoining
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  text: 'Unirse',
                  onPressed: _joinRestaurant,
                ),
        ],
      ),
    );
  }
}
