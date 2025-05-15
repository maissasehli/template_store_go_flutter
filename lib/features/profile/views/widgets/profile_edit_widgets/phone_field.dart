import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/colors.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.phone,
              size: 14,
              color: AppColors.primaryForeground(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  focusedBorder: InputBorder.none,
                  focusColor: Colors.transparent,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: 'Phone number',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 10,
                    letterSpacing: 0.25,
                    color: AppColors.mutedForeground(context),
                  ),
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
          ),
        ],
      ),
    );
  }
}
