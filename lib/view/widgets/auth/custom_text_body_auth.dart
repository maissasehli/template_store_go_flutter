import 'package:flutter/material.dart';

class CustomTextBodyAuth extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator; // Add validator parameter

  const CustomTextBodyAuth({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator, // Optional validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Changed from TextField to TextFormField
      controller: controller,
      obscureText: obscureText,
      validator: validator, // Add validator
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
