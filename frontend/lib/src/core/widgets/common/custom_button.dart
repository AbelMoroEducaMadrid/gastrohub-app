import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? iconAssetPath;
  final IconData? iconData;
  final double iconSize;
  final double fontSize;
  final MainAxisAlignment alignment;
  final bool isSvg;
  final IconPosition iconPosition;
  final Color? iconColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.iconAssetPath,
    this.iconData,
    this.iconSize = 24.0,
    this.fontSize = 16.0,
    this.alignment = MainAxisAlignment.center,
    this.isSvg = true,
    this.iconPosition = IconPosition.left,
    this.iconColor,
  }) : assert(iconAssetPath == null || iconData == null,
            'No se pueden proporcionar iconAssetPath y iconData al mismo tiempo');

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor;
    final fgColor = foregroundColor ?? Colors.white;

    Widget? iconWidget;
    if (iconData != null) {
      iconWidget = Icon(
        iconData,
        size: iconSize,
        color: iconColor ?? fgColor,
      );
    } else if (iconAssetPath != null) {
      iconWidget = isSvg
          ? SvgPicture.asset(
              iconAssetPath!,
              height: iconSize,
              width: iconSize,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  : null,
            )
          : Image.asset(
              iconAssetPath!,
              height: iconSize,
              width: iconSize,
              color: iconColor,
            );
    }

    List<Widget> children = [];
    if (iconPosition == IconPosition.left && iconWidget != null) {
      children.add(iconWidget);
      children.add(const SizedBox(width: 8));
    }
    children.add(Text(
      text,
      style: TextStyle(fontSize: fontSize, color: fgColor),
    ));
    if (iconPosition == IconPosition.right && iconWidget != null) {
      children.add(const SizedBox(width: 8));
      children.add(iconWidget);
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
