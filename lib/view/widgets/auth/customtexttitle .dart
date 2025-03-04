import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CustomTextTitle({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? AppColor.headingLarge,
      textAlign: TextAlign.center,
    );
  }
}