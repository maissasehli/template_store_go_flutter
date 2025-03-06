import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextFormAuth extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator; // Add validator parameter

  const CustomTextFormAuth({
    Key? key, 
    required this.controller, 
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator, // Optional validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField( // Changed from TextField to TextFormField
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
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
      style: TextStyle(
        color: AppColor.textPrimaryColor,
      ),
    );
  }
}