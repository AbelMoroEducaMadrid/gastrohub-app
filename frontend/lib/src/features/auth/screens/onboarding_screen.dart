import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/backgrounds/background_image.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildImageWithCircle(
      BuildContext context, String assetPath, String semanticsLabel) {
    final screenSize = MediaQuery.of(context).size;
    final circleSize = screenSize.width * 0.9;
    final imageSize = screenSize.width * 0.5;

    return Center(
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(150),
        ),
        child: Center(
          child: SvgPicture.asset(
            assetPath,
            height: imageSize,
            semanticsLabel: semanticsLabel,
            colorFilter: assetPath == 'assets/images/logo.svg'
                ? ColorFilter.mode(
                    AppTheme.secondaryColor,
                    BlendMode.srcIn,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageDecoration = PageDecoration(
      bodyFlex: 2,
      imageFlex: 4,
      contentMargin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
    );

    final List<PageViewModel> pages = [
      PageViewModel(
        decoration: pageDecoration,
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
        image: _buildImageWithCircle(
          context,
          'assets/images/logo.svg',
          'Ilustración de bienvenida',
        ),
      ),
      PageViewModel(
        decoration: pageDecoration,
        titleWidget: Text(
          "Comandas en tiempo real",
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          "Registra comandas desde tu móvil y coordínate con la cocina al instante.",
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        image: _buildImageWithCircle(
          context,
          'assets/images/orders.svg',
          'Ilustración de comandas',
        ),
      ),
      PageViewModel(
        decoration: pageDecoration,
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
        image: _buildImageWithCircle(
          context,
          'assets/images/inventory.svg',
          'Ilustración de inventario',
        ),
      ),
      PageViewModel(
        decoration: pageDecoration,
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
        image: _buildImageWithCircle(
          context,
          'assets/images/payments.svg',
          'Ilustración de pagos',
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(image: 'assets/images/background_00.png'),
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: IntroductionScreen(
                  pages: pages,
                  onDone: () => _goToLogin(context),
                  onSkip: () => _goToLogin(context),
                  showSkipButton: true,
                  skip: Text("Omitir",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.hyperlinkColor,
                      )),
                  next: Text("Siguiente",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.hyperlinkColor,
                      )),
                  done: Text("Comenzar",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.hyperlinkColor,
                      )),
                  dotsDecorator: DotsDecorator(
                    activeColor: AppTheme.primaryColor,
                    color: AppTheme.textColor.withAlpha((255 * 0.5).toInt()),
                    size: const Size(10.0, 10.0),
                    activeSize: const Size(22.0, 10.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  globalBackgroundColor: Colors.transparent,
                  isProgress: true,
                  freeze: false,
                  animationDuration: 300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
