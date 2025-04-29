import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/view/widgets/quick_tag.dart';

class EditReviewForm extends StatelessWidget {
  final Review review;
  final RxInt editRating;
  final TextEditingController editCommentController;
  final RxBool isSubmitting;
  final Function(String) onSubmit;
  final VoidCallback onCancel;

   EditReviewForm({
    super.key,
    required this.review,
    required this.editRating,
    required this.editCommentController,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onCancel,
  });

  final List<String> _quickTags = [
    'Great quality',
    'Good value',
    'Fast shipping',
    'As described',
    'Perfect fit',
    'Highly recommend'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Your Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
              GestureDetector(
                onTap: onCancel,
                child: Icon(Icons.close, color: Colors.grey[700], size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => editRating.value = index + 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        index < editRating.value ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 32,
                        color: index < editRating.value ? const Color(0xFFFFCC00) : Colors.grey[300],
                      ),
                    ),
                  );
                }),
              )),
          const SizedBox(height: 20),
          const Text(
            'Your Review',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: editCommentController,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Share your experience with this product...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins'),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quick Tags',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickTags
                .map((tag) => QuickTag(
                      text: tag,
                      onTap: () {
                        if (editCommentController.text.isEmpty) {
                          editCommentController.text = tag;
                        } else if (!editCommentController.text.endsWith('.')) {
                          editCommentController.text += '. $tag';
                        } else {
                          editCommentController.text += ' $tag';
                        }
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting.value ? null : () => onSubmit(review.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isSubmitting.value
                  ? const SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text(
                      'Update Review',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}