import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/models/payment_plan.dart';
import 'package:gastrohub_app/src/auth/providers/auth_provider.dart';
import 'package:gastrohub_app/src/auth/providers/payment_plan_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SelectPlanScreen extends ConsumerStatefulWidget {
  const SelectPlanScreen({super.key});

  @override
  ConsumerState<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends ConsumerState<SelectPlanScreen> {
  int? selectedPlanId;
  List<PaymentPlan>? plans;
  bool isLoading = true;
  String? error;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPlans();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  void _showPlanDialog(BuildContext context) {
    if (plans == null || plans!.isEmpty) return;
    final selectedPlan = plans![_currentPage];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Plan Seleccionado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${selectedPlan.name}'),
              Text('Descripción: ${selectedPlan.description}'),
              Text('Precio mensual: \$${selectedPlan.monthlyPrice}'),
              Text('Descuento anual: ${selectedPlan.yearlyDiscount}%'),
              if (selectedPlan.maxUsers != null)
                Text('Máximo de usuarios: ${selectedPlan.maxUsers}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(title: const Text('Selecciona un plan')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: plans!.length,
              itemBuilder: (context, index) {
                return PlanPage(plan: plans![index]);
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: plans!.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.blue,
              dotColor: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showPlanDialog(context),
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanPage extends StatelessWidget {
  final PaymentPlan plan;

  const PlanPage({required this.plan, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            plan.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(plan.description),
          const SizedBox(height: 16),
          Text(
            'Precio mensual: \$${plan.monthlyPrice}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Descuento anual: ${plan.yearlyDiscount}%',
            style: const TextStyle(fontSize: 18),
          ),
          if (plan.maxUsers != null) ...[
            const SizedBox(height: 8),
            Text(
              'Máximo de usuarios: ${plan.maxUsers}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ],
      ),
    );
  }
}
