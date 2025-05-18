import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final bool isTextArea; // Nuevo: indica si es un área de texto

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.isTextArea = false, // Por defecto, no es área de texto
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

    // Decoración condicional: borde solo si es área de texto
    final inputDecoration = widget.isTextArea
        ? InputDecoration(
            labelText: widget.label,
            border: OutlineInputBorder(), // Borde para área de texto
            contentPadding: const EdgeInsets.all(12),
          )
        : InputDecoration(
            labelText: widget.label, // Estilo por defecto para una línea
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: theme.primaryColor,
        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        validator: widget.validator,
        onChanged: widget.onChanged,
        minLines: widget.minLines ?? 1,
        maxLines: widget.maxLines ?? 1,
        decoration: inputDecoration,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
