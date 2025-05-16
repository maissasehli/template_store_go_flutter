import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class SizeSelector extends StatelessWidget {
  final String selectedSize;
  final List<String> sizes;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.sizes,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Don't render anything if sizes list is empty
    if (sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.foreground(context),
          ),
        ),
        SizedBox(height: UIConfig.paddingSmall),
        Row(
          children:
              sizes.map((size) {
                final isSelected = selectedSize == size;
                return Padding(
                  padding: EdgeInsets.only(right: UIConfig.paddingMedium - 4),
                  child: GestureDetector(
                    onTap: () => onSizeSelected(size),
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.5),
                        color:
                            isSelected
                                ? AppColors.primary(context)
                                : Colors.transparent,
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primary(context)
                                  : AppColors.border(context),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            fontSize: UIConfig.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? AppColors.primaryForeground(context)
                                    : AppColors.foreground(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
