import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/view/widgets/edit_review_form.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final String? editingReviewId;
  final String? currentUserId;
  final ReviewController reviewController;
  final RxInt editRating;
  final TextEditingController editCommentController;
  final FocusNode editCommentFocusNode;
  final RxBool isSubmitting;
  final Function(Review) onEdit;
  final Function(String) onDelete;
  final Function(String) onSubmitEdit;
  final VoidCallback onCancelEdit;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.editingReviewId,
    required this.currentUserId,
    required this.reviewController,
    required this.editRating,
    required this.editCommentController,
    required this.editCommentFocusNode,
    required this.isSubmitting,
    required this.onEdit,
    required this.onDelete,
    required this.onSubmitEdit,
    required this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final review = reviews[index];
        final isCurrentUserReview =
            currentUserId != null && review.appUserId == currentUserId;
        final isEditing = editingReviewId == review.id;

        if (isEditing) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              color: AppColors.card(context),
              child: Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSubmitting.value
                              ? AppColors.muted(context)
                              : AppColors.border(context),
                    ),
                  ),
                  child: EditReviewForm(
                    review: review,
                    editRating: editRating,
                    editCommentController: editCommentController,
                    editCommentFocusNode: editCommentFocusNode,
                    isSubmitting: isSubmitting,
                    onSubmit: onSubmitEdit,
                    onCancel: onCancelEdit,
                  ),
                ),
              ),
            ),
          );
        }

        // Regular review card
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.card(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.muted(context),
                            child: Text(
                              review.userName[0].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mutedForeground(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            review.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: AppColors.foreground(context),
                            ),
                          ),
                        ],
                      ),
                      if (isCurrentUserReview)
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => onEdit(review),
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: AppColors.primary(context),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: () => onDelete(review.id),
                              icon: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: AppColors.destructive(context),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color:
                              i < review.rating
                                  ? AppColors.accent(context)
                                  : AppColors.muted(context),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(review.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground(context),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  if (review.content != null && review.content!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      review.content!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily: 'Poppins',
                        color: AppColors.foreground(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }, childCount: reviews.length),
    );
  }

  String _formatDate(DateTime date) {
    // Format date to user-friendly string like "May 10, 2025"
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
