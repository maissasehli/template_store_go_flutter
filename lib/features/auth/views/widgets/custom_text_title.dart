import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/colors.dart';

class CustomTextTitle extends StatelessWidget {
  final String text;

  const CustomTextTitle({
    super.key, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppColor.titleLarge.copyWith(
        color: Colors.black,
        fontSize: 34,
      ),
    );
  }
}