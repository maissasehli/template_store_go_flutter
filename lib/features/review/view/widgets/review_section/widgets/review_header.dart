import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ReviewHeader extends StatelessWidget {
  final int reviewCount;
  final VoidCallback onSeeAllPressed;

  const ReviewHeader({
    super.key,
    required this.reviewCount,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (reviewCount > 0)
          TextButton(
            onPressed: onSeeAllPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary(context),
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'See All ($reviewCount)',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: AppColors.primary(context),
              ),
            ),
          ),
      ],
    );
  }
}