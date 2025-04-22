import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/view/widgets/quick_tag.dart';

class ReviewForm extends StatefulWidget {
  final Product product;
  final ReviewController controller;
  final String currentUserId;
  final VoidCallback onCancel;
  final VoidCallback onReviewSubmitted;

  const ReviewForm({
    super.key,
    required this.product,
    required this.controller,
    required this.currentUserId,
    required this.onCancel,
    required this.onReviewSubmitted,
  });

  @override
  ReviewFormState createState() => ReviewFormState();
}

class ReviewFormState extends State<ReviewForm> {
  final _isSubmitting = false.obs;
  final _rating = 0.obs;
  final _commentController = TextEditingController();
  final List<String> _quickTags = [
    'Great quality',
    'Good value',
    'Fast shipping',
    'As described',
    'Perfect fit',
    'Highly recommend'
  ];
  bool _isDisposed = false; // Flag to track disposal

  @override
  void dispose() {
    _isDisposed = true; // Set the flag before disposing
    _commentController.dispose();
    super.dispose();
  }

  void _addQuickTag(String tag) {
    if (_isDisposed || !mounted) return; // Prevent access after disposal

    // Use a local variable to avoid repeated controller access
    String currentText = _commentController.text;
    if (currentText.isEmpty) {
      _commentController.text = tag;
    } else if (!currentText.endsWith('.')) {
      _commentController.text = '$currentText. $tag';
    } else {
      _commentController.text = '$currentText $tag';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(red: 0, green: 0, blue: 0, alpha: 0.05),
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
                'Your Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
              GestureDetector(
                onTap: () {
                  if (_isDisposed || !mounted) return;
                  // Clear state before calling onCancel
                  _rating.value = 0;
                  _commentController.clear();
                  widget.onCancel(); // This might dispose the widget
                },
                child: Icon(Icons.close, color: Colors.grey[700], size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (_isDisposed || !mounted) return;
                      _rating.value = index + 1;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        index < _rating.value ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 32,
                        color: index < _rating.value ? const Color(0xFFFFCC00) : Colors.grey[300],
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
              controller: _commentController,
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
            children: _quickTags.map((tag) => QuickTag(text: tag, onTap: () => _addQuickTag(tag))).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting.value
                  ? null
                  : () async {
                      if (_isDisposed || !mounted) return;
                      if (_rating.value == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a rating'), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      if (_isSubmitting.value) return;
                      _isSubmitting.value = true;

                      // Store the comment text before clearing the controller
                      final commentText = _commentController.text.isNotEmpty ? _commentController.text : null;
                      if (!_isDisposed && mounted) {
                        _commentController.clear();
                        _rating.value = 0;
                      }

                      final review = Review(
                        id: DateTime.now().toString(),
                        userName: 'You',
                        rating: _rating.value,
                        content: commentText,
                        createdAt: DateTime.now(),
                        appUserId: widget.currentUserId,
                      );

                      await widget.controller.addReview(widget.product.id, review);
                      await widget.controller.fetchReviews(widget.product.id);
                      if (!_isDisposed && mounted) {
                        widget.onReviewSubmitted(); // This might dispose the widget
                        _isSubmitting.value = false;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Review submitted successfully'), backgroundColor: Colors.green),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isSubmitting.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text(
                      'Submit Review',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}