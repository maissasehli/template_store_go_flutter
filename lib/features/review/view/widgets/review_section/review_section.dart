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
  final _isSubmitting = false.obs;
  final _rating = 0.obs;
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  final List<String> _quickTags = [
    'Great quality',
    'Good value',
    'Fast shipping',
    'As described',
    'Perfect fit',
    'Highly recommend',
  ];
  String? _currentUserId;
  bool _isShimmerVisible = true;

  @override
  void initState() {
    super.initState();

    // Fetch current user ID asynchronously
    Get.find<AuthService>().getCurrentUserId().then((userId) {
      if (mounted) {
        setState(() {
          _currentUserId = userId;
          if (_currentUserId == null) {
            debugPrint('No authenticated user found');
          }
        });
      }
    });

    if (!Get.isRegistered<ReviewController>()) {
      final apiClient = Get.find<ApiClient>();
      final repository = ReviewRepository(apiClient: apiClient);
      Get.put(ReviewController(repository: repository));
    }

    controller = Get.find<ReviewController>();
    controller.reviews.assignAll(widget.initialReviews);

    // Fetch reviews
    _initializeReviews();

    // Add listener for focus management
    _commentFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // Ensure UI updates when focus changes
    if (mounted) {
      setState(() {
        // Force rebuild when focus changes
        if (_commentFocusNode.hasFocus) {
          _isShimmerVisible = false; // Ensure shimmer is hidden when focused
        }
      });
    }
  }

  Future<void> _initializeReviews() async {
    try {
      // Don't show loading if we already have initial reviews
      if (widget.initialReviews.isEmpty) {
        controller.isLoading.value = true;
      }

      await controller.fetchReviews(widget.product.id);
    } catch (e) {
      debugPrint('Error initializing reviews: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to load reviews',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      controller.isLoading.value = false;
      // Update shimmer visibility after loading
      if (mounted) {
        setState(() {
          _isShimmerVisible = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentFocusNode.removeListener(_onFocusChange);
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  double get averageRating {
    if (controller.reviews.isEmpty) return 0;
    return controller.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        controller.reviews.length;
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
        if (controller.isLoading.value && _isShimmerVisible) {
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
            _isWritingReview.value
                ? _buildReviewForm(context)
                : const SizedBox.shrink(),
          ],
        );
      }),
    );
  }

  Widget _buildSkeletonLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.muted(context).withOpacity(0.3),
      highlightColor: AppColors.muted(context).withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 20,
                color: AppColors.background(context),
              ),
              Container(
                width: 80,
                height: 20,
                color: AppColors.background(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      color: AppColors.background(context),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            width: 14,
                            height: 14,
                            color: AppColors.background(context),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 60,
                      height: 12,
                      color: AppColors.background(context),
                    ),
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
                            Container(
                              width: 12,
                              height: 12,
                              color: AppColors.background(context),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 6,
                                color: AppColors.background(context),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 20,
                              height: 12,
                              color: AppColors.background(context),
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  color: AppColors.background(context),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 14,
                  color: AppColors.background(context),
                ),
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
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.foreground(context),
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
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: AppColors.foreground(context),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < averageRating.round()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 14,
                      color: AppColors.accent(context),
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  '${controller.reviews.length} ${controller.reviews.length == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground(context),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final ratingCount = 5 - index;
                  final reviewsWithThisRating =
                      controller.reviews
                          .where((r) => r.rating == ratingCount)
                          .length;
                  final percentage =
                      controller.reviews.isEmpty
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
                              color: AppColors.mutedForeground(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: AppColors.muted(context),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.accent(context),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 20,
                          child: Text(
                            '$reviewsWithThisRating',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedForeground(context),
                            ),
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
    final hasReviewed =
        _currentUserId != null &&
        controller.reviews.any((r) => r.appUserId == _currentUserId);

    return GestureDetector(
      onTap: () {
        if (!hasReviewed && _currentUserId != null) {
          _isWritingReview.value = true;
          setState(() {
            _isShimmerVisible = false; // Ensure shimmer is hidden
          });

          // Defer focus request to avoid conflicts
          Future.delayed(const Duration(milliseconds: 200), () {
            if (_commentFocusNode.canRequestFocus && mounted) {
              _commentFocusNode.requestFocus();
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 18,
              color:
                  hasReviewed
                      ? AppColors.muted(context)
                      : AppColors.primary(context),
            ),
            const SizedBox(width: 8),
            Text(
              hasReviewed ? 'You Already Reviewed' : 'Write a Review',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color:
                    hasReviewed
                        ? AppColors.muted(context)
                        : AppColors.primary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm(BuildContext context) {
    // Use Material widget to ensure text input works correctly
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground(context).withOpacity(0.05),
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
                Text(
                  'Your Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: AppColors.foreground(context),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _isWritingReview.value = false;
                    _rating.value = 0;
                    _commentController.clear();
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.mutedForeground(context),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _rating.value = index + 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        index < _rating.value
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 32,
                        color:
                            index < _rating.value
                                ? AppColors.accent(context)
                                : AppColors.muted(context),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.input(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: TextField(
                // Changed to TextField for simplicity
                controller: _commentController,
                focusNode: _commentFocusNode,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: AppColors.inputForeground(context),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  hintText: 'Share your experience with this product...',
                  hintStyle: TextStyle(
                    color: AppColors.mutedForeground(context),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.input(context),
                ),
                textInputAction: TextInputAction.done,
                onTap: () {
                  setState(() {
                    _isShimmerVisible =
                        false; // Ensure shimmer is hidden on tap
                  });
                  if (!_commentFocusNode.hasFocus && mounted) {
                    _commentFocusNode.requestFocus();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quick Tags',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.foreground(context),
              ),
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
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      _isSubmitting.value
                          ? null
                          : () async {
                            if (_rating.value == 0) {
                              Get.snackbar(
                                'Error',
                                'Please select a rating',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            // Validate comment text
                            if (_commentController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please write a review comment',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            _isSubmitting.value = true;

                            try {
                              final review = Review(
                                id:
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                userName: 'You',
                                rating: _rating.value,
                                content: _commentController.text,
                                createdAt: DateTime.now(),
                                appUserId: _currentUserId ?? 'anonymous',
                              );

                              await controller.addReview(
                                widget.product.id,
                                review,
                              );
                              await controller.fetchReviews(widget.product.id);

                              _commentController.clear();
                              _rating.value = 0;
                              _isWritingReview.value = false;
                            } catch (e) {
                              debugPrint('Error submitting review: $e');
                              Get.snackbar(
                                'Error',
                                'Failed to submit review',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } finally {
                              _isSubmitting.value = false;
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    foregroundColor: AppColors.primaryForeground(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child:
                      _isSubmitting.value
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryForeground(context),
                            ),
                          )
                          : Text(
                            'Submit Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: AppColors.primaryForeground(context),
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
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

        // Ensure focus is on the text field after adding a tag
        if (!_commentFocusNode.hasFocus && mounted) {
          _commentFocusNode.requestFocus();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.muted(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: AppColors.foreground(context),
          ),
        ),
      ),
    );
  }
}
