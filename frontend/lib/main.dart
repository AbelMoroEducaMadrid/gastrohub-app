import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrohub_app/src/auth/screens/login_screen.dart';
import 'package:gastrohub_app/src/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastro & Hub',
      theme: AppTheme.lightTheme, // Use the custom theme
      home: LoginScreen(),
    );
  }
}