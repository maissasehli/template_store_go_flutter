import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class SizeSelector extends StatelessWidget {
  final String? selectedSize;
  final Function(String) onSizeSelected;
  final List<String> availableSizes;

  // ignore: use_super_parameters
  const SizeSelector({
    Key? key,
    required this.selectedSize,
    required this.onSizeSelected,
    this.availableSizes = const ['S', 'M', 'L', 'XL', 'XXL'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: availableSizes
          .map((size) => _buildSizeOption(context, size))
          .toList(),
    );
  }

  Widget _buildSizeOption(BuildContext context, String size) {
    return GestureDetector(
      onTap: () => onSizeSelected(size),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedSize == size
              ? AppColors.primary(context)
              : AppColors.card(context),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: selectedSize == size
                  ? AppColors.primaryForeground(context)
                  : AppColors.foreground(context),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}