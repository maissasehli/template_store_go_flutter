import 'package:flutter/material.dart';
import 'package:store_go/core/constants/color.dart';

class CustomTextTitle extends StatelessWidget {
  final String text;

  const CustomTextTitle({
    Key? key, 
    required this.text,
  }) : super(key: key);

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