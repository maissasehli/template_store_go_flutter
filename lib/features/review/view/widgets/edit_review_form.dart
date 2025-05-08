import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/review/model/review_model.dart';

class EditReviewForm extends StatelessWidget {
  final Review review;
  final RxInt editRating;
  final TextEditingController editCommentController;
  final FocusNode editCommentFocusNode;
  final RxBool isSubmitting;
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  EditReviewForm({
    super.key,
    required this.review,
    required this.editRating,
    required this.editCommentController,
    required this.editCommentFocusNode,
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
    // Request focus when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Short delay to ensure widget is fully rendered
      Future.delayed(const Duration(milliseconds: 100), () {
        if (editCommentFocusNode.canRequestFocus) {
          editCommentFocusNode.requestFocus();
        }
      });
    });

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
          GestureDetector(
            onTap: () {
              // Ensure focus is requested when container tapped
              if (editCommentFocusNode.canRequestFocus) {
                editCommentFocusNode.requestFocus();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: editCommentController,
                focusNode: editCommentFocusNode,
                maxLines: 1, // Allow multiple lines
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                  color: Colors.black87, 
                  fontSize: 14, 
                  fontFamily: 'Poppins'
                ),
                decoration: InputDecoration(
                  hintText: 'Share your experience with this product...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14, fontFamily: 'Poppins'),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                // Don't use onTap here since we're using a GestureDetector already
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
                .map((tag) => _buildQuickTag(tag))
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
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
            )),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickTag(String text) {
    return GestureDetector(
      onTap: () {
        if (editCommentController.text.isEmpty) {
          editCommentController.text = text;
        } else if (!editCommentController.text.endsWith('.')) {
          editCommentController.text += '. $text';
        } else {
          editCommentController.text += ' $text';
        }
        
        // Move cursor to the end after adding tag
        editCommentController.selection = TextSelection.fromPosition(
          TextPosition(offset: editCommentController.text.length),
        );
        
        // Refocus on the text field
        if (editCommentFocusNode.canRequestFocus) {
          editCommentFocusNode.requestFocus();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.black87),
        ),
      ),
    );
  }
}