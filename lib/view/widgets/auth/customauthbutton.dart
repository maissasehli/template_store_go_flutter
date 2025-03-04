import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomAuthButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColor.secondaryColor,
        padding: EdgeInsets.symmetric(vertical: AppColor.spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
        ),
      ),
      child: Text(
        text,
        style: AppColor.bodyLarge.copyWith(
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}