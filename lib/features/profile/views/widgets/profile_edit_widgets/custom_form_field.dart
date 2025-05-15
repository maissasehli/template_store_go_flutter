import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: UIConfig.paddingSmall, 
            bottom: UIConfig.paddingSmall / 2,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.mutedForeground(context),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.input(context),
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
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
                contentPadding: EdgeInsets.only(
                  top: UIConfig.paddingSmall,
                  bottom: 0,
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.inputForeground(context),
              ),
              cursorColor: AppColors.primary(context),
            ),
          ),
        ),
      ],
    );
  }
}