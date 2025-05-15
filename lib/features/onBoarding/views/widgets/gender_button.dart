import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/colors.dart';

class GenderButton extends StatelessWidget {
  final RxnString selectedGender;
  final String text;
  final String gender;
  final Function(String) onGenderSelected;

  const GenderButton({
    super.key,
    required this.selectedGender,
    required this.text,
    required this.gender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final isSelected = selectedGender.value == gender;
        return Container(
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primary(context)
                    : AppColors.background(context),
            border: Border.all(color: AppColors.border(context)),
            borderRadius: BorderRadius.circular(AppColor.globalBorderRadius),
          ),
          child: ElevatedButton(
            onPressed: () => onGenderSelected(gender),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppColor.globalBorderRadius,
                ),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color:
                    isSelected
                        ? AppColors.primaryForeground(context)
                        : AppColors.foreground(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}
