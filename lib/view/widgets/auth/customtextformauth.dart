import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextFormAuth extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;

  const CustomTextFormAuth({
    Key? key, 
    required this.controller, 
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
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
      style: TextStyle(
        color: AppColor.textPrimaryColor,
      ),
    );
  }
}