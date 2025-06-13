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
  final Color? textColor; 
  final Color? borderColor;
  final Color? cursorColor; 
  final Color? placeholderColor;

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
    this.textColor,
    this.borderColor,
    this.cursorColor,
    this.placeholderColor,
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
    
    final textColor = widget.textColor ?? theme.textTheme.bodyMedium?.color ?? Colors.black;
    final borderColor = widget.borderColor ?? theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey;
    final cursorColor = widget.cursorColor ?? theme.textTheme.bodyMedium?.color ?? Colors.black;
    final placeholderColor = widget.placeholderColor ?? theme.inputDecorationTheme.labelStyle?.color ?? Colors.grey;

    final prefixIcon = widget.icon != null
        ? Icon(
            widget.icon,
            color: textColor,
          )
        : null;

    final inputDecoration = InputDecoration(
      labelText: widget.label,
      prefixIcon: prefixIcon,
      suffixIcon: widget.obscureText
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: textColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      contentPadding: widget.isTextArea
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      filled: widget.fillColor != null,
      fillColor: widget.fillColor ?? theme.inputDecorationTheme.fillColor,
      labelStyle: TextStyle(color: placeholderColor),
      hintStyle: TextStyle(color: placeholderColor),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: cursorColor,
        style: TextStyle(color: textColor),
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