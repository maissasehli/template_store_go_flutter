import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextFormAuth extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextFormAuth({
    Key? key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.inputTextColor),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: AppColor.inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}