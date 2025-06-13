import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T>? validator;
  final Color? textColor; 
  final Color? borderColor;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);   
    final textColor = this.textColor ?? theme.textTheme.bodyMedium?.color ?? Colors.black;
    final borderColor = this.borderColor ?? theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0),
          ),
          labelStyle: TextStyle(color: textColor),
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item.value,
            child: Text(
              item.child.toString(),
              style: TextStyle(color: textColor),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}