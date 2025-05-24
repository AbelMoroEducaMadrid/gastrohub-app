import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/features/restaurant/models/payment_plan.dart';
import 'package:gastrohub_app/src/features/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/features/restaurant/providers/payment_plan_provider.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/core/widgets/common/custom_button.dart';
import 'package:gastrohub_app/src/core/widgets/backgrounds/background_image.dart';
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
          style: theme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.secondaryColor,
            fontSize: 66,
          ),
          textAlign: TextAlign.center,
        ),
        bodyWidget: Center(
          child: Card(
            color: Colors.black.withAlpha((255 * 0.6).toInt()),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    plan.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (plan.features.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ...plan.features.map((feature) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.check,
                                        size: 16,
                                        color: AppTheme.hyperlinkColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (plan.monthlyPrice == 0 && plan.yearlyDiscount == 0)
                    Text(
                      'Contactar para Detalles',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.hyperlinkColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${plan.monthlyPrice.toStringAsFixed(2)}€',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: AppTheme.hyperlinkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 70,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '/mes',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${(plan.monthlyPrice * 12 * (1 - plan.yearlyDiscount / 100)).toStringAsFixed(2)}€',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '/año',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ahorra un ${plan.yearlyDiscount}% pagando anualmente',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.hyperlinkColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Seleccionar',
                    onPressed: () {
                      print('Plan seleccionado: ${plan.name}, ID: ${plan.id}');
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
            ),
          ),
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppTheme.secondaryColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BackgroundImage(image: 'assets/images/background_01.png'),
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: IntroductionScreen(
                  pages: _buildPlanPages(plans!),
                  showDoneButton: false,
                  showNextButton: true,
                  showBackButton: true,
                  back: Text(
                    'Anterior',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.hyperlinkColor,
                    ),
                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
