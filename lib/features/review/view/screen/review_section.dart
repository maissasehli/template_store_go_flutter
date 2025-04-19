import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/app/core/services/api_client.dart';

class ReviewSection extends StatefulWidget {
  final List<Review> initialReviews;
  final Product product;

  const ReviewSection({
    super.key,
    required this.initialReviews,
    required this.product,
  });

  @override
  ReviewSectionState createState() => ReviewSectionState();
}

class ReviewSectionState extends State<ReviewSection> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _expanded = false;
  late ReviewController controller;

  @override
  void initState() {
    super.initState();

    // Check if ReviewController already exists, if not create it
    if (!Get.isRegistered<ReviewController>()) {
      final apiClient = Get.find<ApiClient>();
      final repository = ReviewRepository(apiClient: apiClient);
      Get.put(ReviewController(repository: repository));
    }

    controller = Get.find<ReviewController>();
    controller.reviews.assignAll(widget.initialReviews);
    controller.fetchReviews(widget.product.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_expanded) const SizedBox(height: 8),
        if (!_expanded)
          GestureDetector(
            onTap: () {
              setState(() {
                _expanded = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Comment (Optional)',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      child: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        size: 16,
                        color: index < _rating
                            ? const Color(0xFFFFCC00)
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Your Comment (Optional)',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_rating > 0) {
                            final review = Review(
                              id: DateTime.now().toString(),
                              userName: 'Anonymous',
                              rating: _rating,
                              content: _commentController.text.isNotEmpty
                                  ? _commentController.text
                                  : null,
                              createdAt: DateTime.now(),
                            );
                            await controller.addReview(widget.product.id, review);
                            _commentController.clear();
                            setState(() {
                              _rating = 0;
                              _expanded = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a rating')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _rating = 5;
                          _commentController.text = 'Love the design!';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text(
                        'Love the design!',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (controller.reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'No reviews yet.',
              style: TextStyle(
                color: AppColors.mutedForeground(context),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
      ],
    ));
  }
}