import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 58, 90, 64);
  static const Color secondaryColor = Color.fromARGB(255, 88, 129, 87);
  static const Color backgroundColor = Color.fromARGB(255, 218, 215, 205);
  static const Color textColor = Color.fromARGB(255, 52, 78, 65);
  static const Color errorColor = Color.fromARGB(255, 176, 0, 32);
  static const Color successColor = Color.fromARGB(255, 46, 125, 50);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'BebasNeue',
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2.0),
        ),
        labelStyle: TextStyle(color: secondaryColor),
        errorStyle: TextStyle(color: errorColor, fontSize: 12),
      ),
      dividerTheme: DividerThemeData(
        color: secondaryColor.withAlpha(130),
        thickness: 1,
        space: 16,
      ),
    );
  }
}
