import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final bool isTextArea;
  final IconData? icon;
  final TextInputType? keyboardType;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.isTextArea = false,
    this.icon,
    this.keyboardType,
    this.fillColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final prefixIcon = widget.icon != null
        ? Icon(
            widget.icon,
            color: theme.textTheme.bodyMedium?.color,
          )
        : null;

    final inputDecoration = InputDecoration(
      labelText: widget.label,
      prefixIcon: prefixIcon,
      suffixIcon: widget.obscureText
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: theme.textTheme.bodyMedium?.color,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
      border: widget.isTextArea
          ? const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            )
          : const OutlineInputBorder(),
      contentPadding: widget.isTextArea
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      filled: widget.fillColor != null,
      fillColor: widget.fillColor ?? theme.inputDecorationTheme.fillColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: theme.textTheme.bodyMedium?.color,
        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        validator: widget.validator,
        onChanged: widget.onChanged,
        minLines: widget.isTextArea ? (widget.minLines ?? 3) : 1,
        maxLines: widget.isTextArea ? (widget.maxLines ?? 5) : 1,
        decoration: inputDecoration,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
