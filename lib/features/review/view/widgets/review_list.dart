import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/view/widgets/edit_review_form.dart';
import 'package:store_go/features/review/view/widgets/no_filter_results_state.dart';
import 'package:store_go/features/review/view/widgets/review_item.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final String? editingReviewId;
  final String? currentUserId;
  final ReviewController reviewController;
  final RxInt editRating;
  final TextEditingController editCommentController;
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
    required this.isSubmitting,
    required this.onEdit,
    required this.onDelete,
    required this.onSubmitEdit,
    required this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const SliverFillRemaining(
        child: NoFilterResultsState(),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final review = reviews[index];
            if (editingReviewId == review.id) {
              return EditReviewForm(
                review: review,
                editRating: editRating,
                editCommentController: editCommentController,
                isSubmitting: isSubmitting,
                onSubmit: onSubmitEdit,
                onCancel: onCancelEdit,
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(bottom: index < reviews.length - 1 ? 16 : 0),
                child: ReviewItem(
                  review: review,
                  currentUserId: currentUserId,
                  isSubmitting: isSubmitting,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              );
            }
          },
          childCount: reviews.length,
        ),
      ),
    );
  }
}