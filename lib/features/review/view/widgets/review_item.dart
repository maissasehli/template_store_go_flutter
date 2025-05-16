import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/review/model/review_model.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  final String? currentUserId;
  final RxBool isSubmitting;
  final Function(Review) onEdit;
  final Function(String) onDelete;

  const ReviewItem({
    super.key,
    required this.review,
    required this.currentUserId,
    required this.isSubmitting,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(review.createdAt);
    final isCurrentUser =
        currentUserId != null && review.appUserId == currentUserId;

    // Base review content
    Widget reviewContent = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.muted(context),
                radius: 20,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedForeground(context),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName.isNotEmpty
                              ? review.userName
                              : 'Anonymous',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: AppColors.foreground(context),
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: AppColors.mutedForeground(context),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: AppColors.accent(context),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.content != null && review.content!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 52.0),
              child: Text(
                review.content!,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: AppColors.foreground(context),
                  height: 1.4,
                ),
              ),
            ),
          if (isCurrentUser && isSubmitting.value)
            const Padding(
              padding: EdgeInsets.only(top: 12.0, left: 52.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );

    // If it's not the current user, return the basic review
    if (!isCurrentUser) {
      return reviewContent;
    }

    // For the current user, wrap in Dismissible for swipe-to-delete
    return Dismissible(
      key: Key(review.id),
      // Allow swipe from both sides
      direction: DismissDirection.horizontal,
      // Background when swiping from start to end (right)
      background: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          color: AppColors.destructive(context),
          child: Icon(
            Icons.delete_outline,
            color: AppColors.destructiveForeground(context),
          ),
        ),
      ),
      // Background when swiping from end to start (left)
      secondaryBackground: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: AppColors.destructive(context),
          child: Icon(
            Icons.delete_outline,
            color: AppColors.destructiveForeground(context),
          ),
        ),
      ),
      // Just confirm directly without showing the dialog
      // (since we'll handle it in the ReviewPage)
      confirmDismiss: (direction) async {
        return true;
      },
      // Execute deletion when dismissed
      onDismissed: (direction) {
        onDelete(review.id);
      },
      child: GestureDetector(
        onTap: isSubmitting.value ? null : () => onEdit(review),
        child: reviewContent,
      ),
    );
  }
}
