import 'package:flutter/material.dart';
import 'package:gastrohub_app/src/features/restaurant/models/payment_plan.dart';
import 'package:gastrohub_app/src/features/dashboard/screens/dashboard_screen.dart';
import 'package:gastrohub_app/src/features/auth/screens/login_screen.dart';
import 'package:gastrohub_app/src/features/auth/screens/onboarding_screen.dart';
import 'package:gastrohub_app/src/features/auth/screens/registration_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/restaurant_registration_screen.dart';
import 'package:gastrohub_app/src/features/restaurant/screens/select_plan_screen.dart';
import 'package:gastrohub_app/src/features/auth/screens/verification_pending_screen.dart';
import 'package:gastrohub_app/src/features/auth/screens/welcome_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String welcome = '/welcome';
  static const String selectPlan = '/select-plan';
  static const String verificationPending = '/verification-pending';
  static const String restaurantRegistration = '/restaurant-registration';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegistrationScreen(),
      dashboard: (context) => const DashboardScreen(),
      welcome: (context) => const WelcomeScreen(),
      selectPlan: (context) => const SelectPlanScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case verificationPending:
        final args = settings.arguments as Map<String, String>?;
        final email = args?['email'] ?? 'email@ejemplo.com';
        final name = args?['name'] ?? 'Nombre';
        return MaterialPageRoute(
          builder: (context) =>
              VerificationPendingScreen(email: email, name: name),
        );
      case restaurantRegistration:
        final plan = settings.arguments as PaymentPlan;
        return MaterialPageRoute(
          builder: (context) => RestaurantRegistrationScreen(plan: plan),
        );
      default:
        return null;
    }
  }
}
