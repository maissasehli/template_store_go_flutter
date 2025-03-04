import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextBodyAuth extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CustomTextBodyAuth({
    Key? key, 
    required this.controller, 
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.inputTextColor),
        filled: true,
        fillColor: AppColor.inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          borderSide: BorderSide.none,
        ),
      ),
      style: AppColor.bodyMedium,
    );
  }
}