import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class CustomDropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;
  
  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.mutedForeground(context),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(
            hintText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.mutedForeground(context),
            ),
          ),
          dropdownColor: AppColors.input(context),
        ),
      ),
    );
  }
}