import 'package:flutter/material.dart';

/// A TextFormField for the floats
class FloatNumberFormField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;

  /// Constructor
  const FloatNumberFormField({super.key, required this.controller, this.decoration});

  /// Function that validates the forms
  String? _validator(String? value) {
    if (value == null) {
      return 'Enter a number!';
    }

    // Try to parse as a float
    if (double.tryParse(value) == null) {
      return 'Please, enter a valid number!';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: decoration,
      validator: _validator,
    );
  }
}
