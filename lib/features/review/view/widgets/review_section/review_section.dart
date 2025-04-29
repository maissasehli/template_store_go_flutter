import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/review/view/screen/review_screen.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class ReviewSection extends StatefulWidget {
  final Product product;
  final List<Review> initialReviews;

  const ReviewSection({
    super.key,
    required this.product,
    required this.initialReviews,
  });

  @override
  ReviewSectionState createState() => ReviewSectionState();
}

class ReviewSectionState extends State<ReviewSection> {
  late ReviewController controller;
  final _isWritingReview = false.obs;
  final _isSubmitting = false.obs; // Added for submission loading state
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
  String? _currentUserId; // Added for user authentication

@override
void initState() {
  super.initState();

  // Fetch current user ID asynchronously
  Get.find<AuthService>().getCurrentUserId().then((userId) {
    setState(() {
      _currentUserId = userId;
      if (_currentUserId == null) {
        debugPrint('No authenticated user found');
      }
    });
  });

  if (!Get.isRegistered<ReviewController>()) {
    final apiClient = Get.find<ApiClient>();
    final repository = ReviewRepository(apiClient: apiClient);
    Get.put(ReviewController(repository: repository));
  }

  controller = Get.find<ReviewController>();
  controller.reviews.assignAll(widget.initialReviews);

  // Fetch reviews (offline sync is handled in ReviewController.onInit)
  _initializeReviews();
}

Future<void> _initializeReviews() async {
  try {
    await controller.fetchReviews(widget.product.id);
  } catch (e) {
    debugPrint('Error initializing reviews: $e');
    Get.snackbar('Error', 'Failed to load reviews', backgroundColor: Colors.red, colorText: Colors.white);
  }
}

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  double get averageRating {
    if (controller.reviews.isEmpty) return 0;
    return controller.reviews.map((r) => r.rating).reduce((a, b) => a + b) / controller.reviews.length;
  }

  void _showAllReviewsPage() {
    Get.to(
      () => ReviewsPage(
        reviews: controller.reviews,
        averageRating: averageRating,
        onAddReview: () {
          Get.back();
          _isWritingReview.value = true;
        },
        product: widget.product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeletonLoading();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewHeader(),
            const SizedBox(height: 16),
            _buildRatingSummary(),
            const SizedBox(height: 16),
            _buildWriteReviewButton(),
            _isWritingReview.value ? _buildReviewForm(context) : const SizedBox.shrink(),
          ],
        );
      }),
    );
  }

  Widget _buildSkeletonLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 20, color: Colors.white),
              Container(width: 80, height: 20, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(width: 40, height: 40, color: Colors.white),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(width: 14, height: 14, color: Colors.white),
                        );
                      }),
                    ),
                    const SizedBox(height: 2),
                    Container(width: 60, height: 12, color: Colors.white),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 6, color: Colors.white)),
                            const SizedBox(width: 4),
                            Container(width: 20, height: 12, color: Colors.white),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 18, height: 18, color: Colors.white),
                const SizedBox(width: 8),
                Container(width: 100, height: 14, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (controller.reviews.isNotEmpty)
          TextButton(
            onPressed: _showAllReviewsPage,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary(context),
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'See All (${controller.reviews.length})',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: AppColors.primary(context),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingSummary() {
    if (controller.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: _showAllReviewsPage,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < averageRating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 14,
                      color: const Color(0xFFFFCC00),
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  '${controller.reviews.length} ${controller.reviews.length == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Poppins'),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final ratingCount = 5 - index;
                  final reviewsWithThisRating =
                      controller.reviews.where((r) => r.rating == ratingCount).length;
                  final percentage = controller.reviews.isEmpty
                      ? 0.0
                      : reviewsWithThisRating / controller.reviews.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                          child: Text(
                            '$ratingCount',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFCC00)),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 20,
                          child: Text(
                            '$reviewsWithThisRating',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWriteReviewButton() {
    final hasReviewed = _currentUserId != null &&
        controller.reviews.any((r) => r.appUserId == _currentUserId);
    return GestureDetector(
      onTap: hasReviewed || _currentUserId == null ? null : () => _isWritingReview.value = true,
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
              color: hasReviewed || _currentUserId == null
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
                color: hasReviewed || _currentUserId == null
                    ? Colors.grey
                    : AppColors.primary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildReviewForm(BuildContext context) {
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
                _isWritingReview.value = false;
                _rating.value = 0;
                _commentController.clear();
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
                  onTap: () => _rating.value = index + 1,
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
          children: _quickTags.map((tag) => _buildQuickTag(tag)).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting.value
                ? null
                : () async {
                    if (_rating.value == 0) {
                      if (!mounted) return; // Check if widget is still mounted
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a rating'), backgroundColor: Colors.red),
                      );
                      return;
                    }
                    if (_isSubmitting.value) return;
                    _isSubmitting.value = true;

                    final review = Review(
                      id: DateTime.now().toString(),
                      userName: 'You',
                      rating: _rating.value,
                      content: _commentController.text.isNotEmpty ? _commentController.text : null,
                      createdAt: DateTime.now(),
                      appUserId: _currentUserId ?? '',
                    );
                    await controller.addReview(widget.product.id, review);
                    await controller.fetchReviews(widget.product.id);
                    _commentController.clear();
                    _rating.value = 0;
                    _isWritingReview.value = false;
                    _isSubmitting.value = false;
                    
                    // Removed duplicate success SnackBar - The controller already shows one
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

  Widget _buildQuickTag(String text) {
    return GestureDetector(
      onTap: () {
        if (_commentController.text.isEmpty) {
          _commentController.text = text;
        } else if (!_commentController.text.endsWith('.')) {
          _commentController.text += '. $text';
        } else {
          _commentController.text += ' $text';
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