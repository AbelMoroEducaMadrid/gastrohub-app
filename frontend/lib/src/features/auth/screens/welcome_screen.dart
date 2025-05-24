import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/utils/dialog_utils.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/forms/form_container.dart';

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
    Navigator.of(context).pushNamed('/select-plan');
  }

  void _showErrorDialog(String message, {String? title}) {
    DialogUtils.showErrorDialog(
      context: context,
      message: message,
      title: title,
    );
  }

  void _joinRestaurant() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isJoining = true);
      final code = codeController.text;
      try {
        await ref.read(authProvider.notifier).joinRestaurant(code);

        if (!mounted) return;

        final authState = ref.read(authProvider);
        if (authState.error != null) {
          _showErrorDialog(authState.error!, title: authState.errorTitle);
          ref.read(authProvider.notifier).clearError();
        } else {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } catch (e) {
        _showErrorDialog(e.toString());
        ref.read(authProvider.notifier).clearError();
      } finally {
        setState(() => isJoining = false);
      }
    }
  }

  void _scanQRCode() {
    // TODO: Implementar lógica para escanear QR code en el futuro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Escaneo de QR code no implementado aún')),
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppTheme.secondaryColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundImage: 'assets/images/background_01.png',
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
          Text(
            'Bienvenido, ${user.name}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.secondaryColor,
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
            text: 'Elige tu plan',
            onPressed: _createRestaurant,
            iconData: Icons.layers_outlined,
            iconPosition: IconPosition.left,
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
              icon: Icons.storefront_outlined,
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
                        content: Text(
                          'Es un código único que te permite unirte a un establecimiento específico. Pídelo a tu gerente o dueño.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cerrar',
                              style: TextStyle(
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.info_outline,
                  color: AppTheme.textColor,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isJoining
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Escanear QR',
                        onPressed: _scanQRCode,
                        iconData: Icons.qr_code,
                        iconPosition: IconPosition.left,
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 24),
                    CustomButton(
                      text: 'Unirse',
                      onPressed: authState.isLoading || isJoining
                          ? null
                          : _joinRestaurant,
                      iconData: Icons.group_add_outlined,
                      iconPosition: IconPosition.left,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
