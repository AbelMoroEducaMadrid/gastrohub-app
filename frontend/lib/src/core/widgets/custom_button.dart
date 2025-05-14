import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon; // Icono opcional
  final Color? backgroundColor; // Color de fondo opcional

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor =
        theme.elevatedButtonTheme.style?.backgroundColor?.resolve({});
    final effectiveBackgroundColor = backgroundColor ?? defaultBackgroundColor;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveBackgroundColor == Colors.white
          ? Colors.black
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon,
            color: effectiveBackgroundColor == Colors.white
                ? Colors.black
                : Colors.white),
        label: Text(text),
        style: buttonStyle,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: buttonStyle,
      );
    }
  }
}
