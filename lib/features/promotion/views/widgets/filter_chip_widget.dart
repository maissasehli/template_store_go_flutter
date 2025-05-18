import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        labelStyle: TextStyle(
          color: isSelected
              ? AppColors.primaryForeground(context)
              : AppColors.foreground(context),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        label: Text(label),
        backgroundColor: AppColors.muted(context).withOpacity(0.1),
        selectedColor: AppColors.primary(context),
        onSelected: (_) {},
      ),
    );
  }
}