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
        padding: const EdgeInsets.symmetric(vertical: 15),
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
