import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';

class ReviewBottomBar extends StatelessWidget {
  final String? currentUserId;
  final ReviewController reviewController;
  final VoidCallback onAddReview;
  final String productId;

  const ReviewBottomBar({
    super.key,
    required this.currentUserId,
    required this.reviewController,
    required this.onAddReview,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasReviewed = currentUserId != null &&
          reviewController.reviews.any((r) => r.appUserId == currentUserId);

      return Container(
        padding: EdgeInsets.all(UIConfig.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.background(context),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground(context).withOpacity(0.05),
              blurRadius: UIConfig.elevationLarge,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(top: BorderSide(color: AppColors.border(context))),
        ),
        child: ElevatedButton(
          onPressed: hasReviewed || currentUserId == null ? null : onAddReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasReviewed || currentUserId == null
                ? AppColors.muted(context)
                : AppColors.primary(context),
            foregroundColor: AppColors.background(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
            ),
            padding: EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
            elevation: 0,
          ),
          child: Text(
            hasReviewed ? 'You Already Reviewed' : 'Write a Review',
            style: TextStyle(
              fontSize: UIConfig.fontSizeMedium,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    });
  }
}