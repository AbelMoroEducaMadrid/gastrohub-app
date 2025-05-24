import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 131, 11, 11);
  static const Color secondaryColor = Color.fromARGB(255, 255, 110, 110);
  static const Color backgroundColor = Color(0xFFe7ecef);
  static const Color textColor = Colors.white;
  static const Color hyperlinkColor = Color.fromARGB(255, 255, 79, 79);
  static const Color errorColor = Colors.red;

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
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
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
          borderSide: BorderSide(color: textColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 2.0),
        ),
        labelStyle: TextStyle(color: textColor),
        errorStyle: TextStyle(color: errorColor, fontSize: 12),
      ),
      dividerTheme: DividerThemeData(
        color: textColor.withAlpha(130),
        thickness: 1,
        space: 16,
      ),
    );
  }
}
