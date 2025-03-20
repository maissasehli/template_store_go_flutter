import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/colors.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomAuthButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        text,
        style: AppColor.bodyLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
