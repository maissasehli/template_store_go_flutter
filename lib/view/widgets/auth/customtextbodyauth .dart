import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextBodyAuth extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator; // Add validator parameter

  const CustomTextBodyAuth({
    Key? key, 
    required this.controller, 
    required this.hintText,
    this.obscureText = false,
    this.validator, // Optional validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField( // Changed from TextField to TextFormField
      controller: controller,
      obscureText: obscureText,
      validator: validator, // Add validator
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.inputTextColor),
        filled: true,
        fillColor: AppColor.inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
      style: AppColor.bodyMedium,
    );
  }
}