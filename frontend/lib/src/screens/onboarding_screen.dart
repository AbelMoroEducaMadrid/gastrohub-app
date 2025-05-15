import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/themes/introduction_screen_theme.dart';

// Pantalla de onboarding usando introduction_screen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Navegar al login manualmente
  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    // Combinar el tema principal con la extensión para IntroductionScreen
    final theme = Theme.of(context).copyWith(
      extensions: [
        IntroductionScreenTheme.defaultTheme(),
      ],
    );
    // Obtener el tema de IntroductionScreen, con fallback a defaultTheme
    final introTheme = theme.extension<IntroductionScreenTheme>() ??
        IntroductionScreenTheme.defaultTheme();

    // Lista de páginas del onboarding
    final List<PageViewModel> pages = [
      PageViewModel(
        titleWidget: Text(
          "Bienvenido a Gastro & Hub",
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          "Gestiona tu restaurante con rapidez, simplicidad y bajo coste.",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        image: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 200,
            semanticLabel: 'Ilustración de bienvenida',
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          "Pedidos en tiempo real",
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          "Registra pedidos desde tu móvil y coordínate con la cocina al instante.",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        image: Center(
          child: SvgPicture.asset(
            'assets/images/orders.svg',
            height: 200,
            semanticsLabel: 'Ilustración de pedidos',
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          "Controla tu inventario",
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          "Monitorea existencias y recibe alertas para evitar faltantes.",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        image: Center(
          child: SvgPicture.asset(
            'assets/images/inventory.svg',
            height: 200,
            semanticsLabel: 'Ilustración de inventario',
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          "Pagos y cierres fáciles",
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          "Procesa pagos digitales y simplifica el cierre diario de caja.",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        image: Center(
          child: SvgPicture.asset(
            'assets/images/payments.svg',
            height: 200,
            semanticsLabel: 'Ilustración de pagos',
          ),
        ),
      ),
    ];

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: IntroductionScreen(
          pages: pages,
          onDone: () => _goToLogin(context),
          onSkip: () => _goToLogin(context),
          showSkipButton: true,
          skip: Text("Omitir", style: introTheme.skipStyle),
          next: Text("Siguiente", style: introTheme.nextStyle),
          done: Text("Comenzar", style: introTheme.doneStyle),
          dotsDecorator: introTheme.dotsDecorator,
          globalBackgroundColor: AppTheme.backgroundColor,
          isProgress: true,
          freeze: false,
          bodyPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          animationDuration: 300,
        ),
      ),
    );
  }
}
