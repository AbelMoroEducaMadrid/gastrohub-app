import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/core/utils/snackbar_utils.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/core/utils/dialog_utils.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_text_field.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/forms/form_container.dart';
import 'package:gastrohub_app/src/features/auth/screens/qr_scanner_screen.dart';

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
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard',
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        _showErrorDialog(e.toString());
        ref.read(authProvider.notifier).clearError();
      } finally {
        setState(() => isJoining = false);
      }
    }
  }

  void _scanQRCode() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      SnackbarUtils.showAwesomeSnackbar(
        context: context,
        title: 'Información',
        message: 'El escaneo de QR solo está disponible en Android/iOS',
        contentType: ContentType.help,
      );
    } else {
      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const QRScannerScreen()),
      );
      if (result != null && result.isNotEmpty) {
        codeController.text = result;
        SnackbarUtils.showAwesomeSnackbar(
          context: context,
          title: 'Código escaneado',
          message: 'Se ha rellenado el código automáticamente.',
          contentType: ContentType.success,
        );
      }
    }
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
            iconPosition: IconPosition.right,
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
                  SnackbarUtils.showAwesomeSnackbar(
                    context: context,
                    title: 'Información',
                    message: 'Pide el código a un dueño de local.',
                    contentType: ContentType.help,
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
                        iconPosition: IconPosition.right,
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
                      iconPosition: IconPosition.right,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
