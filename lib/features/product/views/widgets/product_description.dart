import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.foreground(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            color: AppColors.mutedForeground(context),
            height: 1.5,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
