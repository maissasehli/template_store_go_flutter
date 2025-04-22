import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(red: 0, green: 0, blue: 0, alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: ElevatedButton(
          onPressed: hasReviewed || currentUserId == null ? null : onAddReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasReviewed || currentUserId == null
                ? Colors.grey
                : AppColors.primary(context),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: Text(
            hasReviewed ? 'You Already Reviewed' : 'Write a Review',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
          ),
        ),
      );
    });
  }
}