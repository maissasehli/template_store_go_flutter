import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    // Don't render anything if description is empty
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.foreground(context),
          ),
        ),
        SizedBox(height: UIConfig.paddingSmall),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.mutedForeground(context),
          ),
        ),
      ],
    );
  }
}