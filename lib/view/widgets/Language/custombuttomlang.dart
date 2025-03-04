import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomBottomLanguage extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const CustomBottomLanguage({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        height: 50,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: AppColor.backgroundColor,
        elevation: 5,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.inputBackgroundColor,
          ),
        ),
      ),
    );
  }
}