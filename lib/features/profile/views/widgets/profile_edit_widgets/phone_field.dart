import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  
  const PhoneField({
    super.key,
    required this.controller,
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
            'Phone number',
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
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: UIConfig.paddingSmall),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent(context),
                  borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
                ),
                child: Icon(
                  Icons.phone,
                  size: 20,
                  color: AppColors.accentForeground(context),
                ),
              ),
              SizedBox(width: UIConfig.paddingSmall),
              Expanded(
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
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}