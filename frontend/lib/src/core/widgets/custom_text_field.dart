import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
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
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: primaryColor,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: textColor),
          hintStyle: TextStyle(color: textColor?.withAlpha(150)),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
