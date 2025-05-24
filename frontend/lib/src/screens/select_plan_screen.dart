import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gastrohub_app/src/auth/models/payment_plan.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/auth/providers/payment_plan_provider.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/background_image.dart';
import 'package:introduction_screen/introduction_screen.dart';

class SelectPlanScreen extends ConsumerStatefulWidget {
  const SelectPlanScreen({super.key});

  @override
  ConsumerState<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends ConsumerState<SelectPlanScreen> {
  List<PaymentPlan>? plans;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final authState = ref.read(authProvider);
    final token = authState.token;
    if (token == null) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    try {
      final paymentPlanService = ref.read(paymentPlanServiceProvider);
      final fetchedPlans = await paymentPlanService.getPaymentPlans(token);
      setState(() {
        plans = fetchedPlans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  List<PageViewModel> _buildPlanPages(List<PaymentPlan> plans) {
    final theme = Theme.of(context);
    return plans.map((plan) {
      return PageViewModel(
        titleWidget: Text(
          plan.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        bodyWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              plan.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Precio mensual: \$${plan.monthlyPrice}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textColor,
              ),
            ),
            Text(
              'Descuento anual: ${plan.yearlyDiscount}%',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textColor,
              ),
            ),
            if (plan.maxUsers != null)
              Text(
                'Máximo de usuarios: ${plan.maxUsers}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textColor,
                ),
              ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Seleccionar este plan',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/restaurant-registration',
                  arguments: plan,
                );
              },
              iconData: Icons.check_circle_outline,
              iconPosition: IconPosition.right,
            ),
          ],
        ),
        decoration: const PageDecoration(
          contentMargin: EdgeInsets.all(16.0),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }
    if (plans == null || plans!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No hay planes disponibles')),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(image: 'assets/images/background_00.png'),
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 150,
                      semanticsLabel: 'Logo de Gastro & Hub',
                      colorFilter: const ColorFilter.mode(
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
                    Expanded(
                      child: IntroductionScreen(
                        pages: _buildPlanPages(plans!),
                        showDoneButton: false,
                        showNextButton: true,
                        showSkipButton: false,
                        next: Text(
                          'Siguiente',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppTheme.hyperlinkColor,
                          ),
                        ),
                        dotsDecorator: DotsDecorator(
                          activeColor: AppTheme.primaryColor,
                          color: AppTheme.textColor.withAlpha((255 * 0.5).toInt()),
                          size: const Size(10.0, 10.0),
                          activeSize: const Size(22.0, 10.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        globalBackgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}