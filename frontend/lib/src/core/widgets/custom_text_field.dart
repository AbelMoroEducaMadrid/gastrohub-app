import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.onChanged,
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Semantics(
        label: widget.label,
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          cursorColor: theme.primaryColor,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: theme.inputDecorationTheme.labelStyle?.color,
            ),
            hintStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(150)),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: theme.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}
