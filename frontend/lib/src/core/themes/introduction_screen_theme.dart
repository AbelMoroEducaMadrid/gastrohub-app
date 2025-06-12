import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';

class IntroductionScreenTheme extends ThemeExtension<IntroductionScreenTheme> {
  final TextStyle skipStyle;
  final TextStyle nextStyle;
  final TextStyle doneStyle;
  final DotsDecorator dotsDecorator;

  const IntroductionScreenTheme({
    required this.skipStyle,
    required this.nextStyle,
    required this.doneStyle,
    required this.dotsDecorator,
  });

  // Estilos por defecto usando AppTheme
  factory IntroductionScreenTheme.defaultTheme() {
    return IntroductionScreenTheme(
      skipStyle: const TextStyle(
        fontSize: 16,
        color: AppTheme.secondaryColor,
        fontWeight: FontWeight.normal,
      ),
      nextStyle: const TextStyle(
        fontSize: 16,
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.normal,
      ),
      doneStyle: const TextStyle(
        fontSize: 16,
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey.shade400,
        activeColor: AppTheme.primaryColor,
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  @override
  ThemeExtension<IntroductionScreenTheme> copyWith({
    TextStyle? skipStyle,
    TextStyle? nextStyle,
    TextStyle? doneStyle,
    DotsDecorator? dotsDecorator,
  }) {
    return IntroductionScreenTheme(
      skipStyle: skipStyle ?? this.skipStyle,
      nextStyle: nextStyle ?? this.nextStyle,
      doneStyle: doneStyle ?? this.doneStyle,
      dotsDecorator: dotsDecorator ?? this.dotsDecorator,
    );
  }

  @override
  ThemeExtension<IntroductionScreenTheme> lerp(
      ThemeExtension<IntroductionScreenTheme>? other, double t) {
    if (other is! IntroductionScreenTheme) {
      return this;
    }
    return IntroductionScreenTheme(
      skipStyle: TextStyle.lerp(skipStyle, other.skipStyle, t)!,
      nextStyle: TextStyle.lerp(nextStyle, other.nextStyle, t)!,
      doneStyle: TextStyle.lerp(doneStyle, other.doneStyle, t)!,
      dotsDecorator: dotsDecorator,
    );
  }
}
