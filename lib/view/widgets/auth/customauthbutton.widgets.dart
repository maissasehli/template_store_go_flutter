import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomAuthButton({
    Key? key, 
    required this.onPressed, 
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
        ),
      ),
      child: Text(
        text,
        style: AppColor.bodyLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}