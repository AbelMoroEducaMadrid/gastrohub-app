import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? iconAssetPath;
  final double iconSize;
  final double fontSize;
  final MainAxisAlignment alignment;
  final bool isSvg;
  final bool rounded;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.iconAssetPath,
    this.iconSize = 24.0,
    this.fontSize = 16.0,
    this.alignment = MainAxisAlignment.center,
    this.isSvg = true,
    this.rounded = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor;
    final fgColor = foregroundColor ?? Colors.white;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        // foregroundColor eliminado
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded ? 12.0 : 0),
        ),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconAssetPath != null) ...[
            isSvg
                ? SvgPicture.asset(
                    iconAssetPath!,
                    height: iconSize,
                    width: iconSize,
                     colorFilter: null,
                  )
                : Image.asset(
                    iconAssetPath!,
                    height: iconSize,
                    width: iconSize,
                  ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(fontSize: fontSize, color: fgColor),
          ),
        ],
      ),
    );
  }
}
