import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/colors.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  
  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: InputBorder.none,
            focusColor: Colors.transparent,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText: label,
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 16 / 10,
              letterSpacing: 0.25,
              color: AppColors.mutedForeground(context),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(top: 8, bottom: 0),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 18 / 14,
            letterSpacing: 0.25,
            color: AppColors.inputForeground(context),
          ),
          cursorColor: AppColors.primary(context),
        ),
      ),
    );
  }
}