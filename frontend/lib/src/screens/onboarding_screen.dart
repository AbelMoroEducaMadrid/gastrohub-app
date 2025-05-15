import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Pantalla de onboarding usando introduction_screen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Navegar al login manualmente
  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    // Lista de páginas del onboarding
    final List<PageViewModel> pages = [
      PageViewModel(
        title: "Bienvenido a Gastro & Hub",
        body: "Gestiona tu restaurante con rapidez, simplicidad y bajo coste.",
        image: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 200,
            semanticLabel: 'Ilustración de bienvenida',
          ),
        ),
      ),
      PageViewModel(
        title: "Pedidos en tiempo real",
        body:
            "Registra pedidos desde tu móvil y coordínate con la cocina al instante.",
        image: Center(
          child: SvgPicture.asset(
            'assets/images/orders.svg',
            height: 200,
            semanticsLabel: 'Ilustración de pedidos',
          ),
        ),
      ),
      PageViewModel(
        title: "Controla tu inventario",
        body: "Monitorea existencias y recibe alertas para evitar faltantes.",
        image: Center(
          child: SvgPicture.asset(
            'assets/images/inventory.svg',
            height: 200,
            semanticsLabel: 'Ilustración de inventario',
          ),
        ),
      ),
      PageViewModel(
        title: "Pagos y cierres fáciles",
        body: "Procesa pagos digitales y simplifica el cierre diario de caja.",
        image: Center(
          child: SvgPicture.asset(
            'assets/images/payments.svg',
            height: 200,
            semanticsLabel: 'Ilustración de pagos',
          ),
        ),
      ),
    ];

    return IntroductionScreen(
      pages: pages,
      onDone: () => _goToLogin(context),
      onSkip: () => _goToLogin(context),
      showSkipButton: true,
      skip: const Text("Omitir", style: TextStyle(fontSize: 16)),
      next: const Text("Siguiente", style: TextStyle(fontSize: 16)),
      done: const Text("Comenzar",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeColor: Colors.blue,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      globalBackgroundColor: Colors.white,
      isProgress: true,
      freeze: false,
    );
  }
}
