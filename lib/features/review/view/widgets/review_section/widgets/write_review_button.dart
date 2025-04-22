import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class WriteReviewButton extends StatelessWidget {
  final bool hasReviewed;
  final bool isAuthenticated;
  final VoidCallback onTap;

  const WriteReviewButton({
    super.key,
    required this.hasReviewed,
    required this.isAuthenticated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasReviewed || !isAuthenticated ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 18,
              color: hasReviewed || !isAuthenticated
                  ? Colors.grey
                  : AppColors.primary(context),
            ),
            const SizedBox(width: 8),
            Text(
              hasReviewed ? 'You Already Reviewed' : 'Write a Review',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: hasReviewed || !isAuthenticated
                    ? Colors.grey
                    : AppColors.primary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}