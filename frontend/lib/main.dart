import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/screens/dashboard_screen.dart';
import 'package:gastrohub_app/src/screens/login_screen.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';
import 'package:gastrohub_app/src/screens/onboarding_screen.dart';
import 'package:gastrohub_app/src/screens/registration_screen.dart';
import 'package:gastrohub_app/src/screens/select_plan_screen.dart';
import 'package:gastrohub_app/src/screens/verification_pending_screen.dart';
import 'package:gastrohub_app/src/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env.local');
    debugPrint(".env.local cargado");
  } catch (_) {
    await dotenv.load(fileName: '.env');
    debugPrint(".env.local no encontrado, usando .env");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gastro & Hub',
      theme: AppTheme.lightTheme,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/select-plan': (context) => const SelectPlanScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/verification-pending') {
          final args = settings.arguments as Map<String, String>?;
          final email = args?['email'] ?? 'email@ejemplo.com';
          final name = args?['name'] ?? 'Nombre';
          return MaterialPageRoute(
            builder: (context) =>
                VerificationPendingScreen(email: email, name: name),
          );
        }
        return null;
      },
    );
  }
}
