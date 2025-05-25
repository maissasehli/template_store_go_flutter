import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/auth/services/auth_service.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/review/view/screen/review_screen.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

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
    final bool isRtl = LocalizationService.isRtl(context);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Obx(() {
        if (controller.isLoading.value && _isShimmerVisible) {
          return _buildSkeletonLoading();
        }
        return Column(
          crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
    final bool isRtl = LocalizationService.isRtl(context);

    return Shimmer.fromColors(
      baseColor: AppColors.muted(context).withOpacity(0.3),
      highlightColor: AppColors.muted(context).withOpacity(0.1),
      child: Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Column(
                  crossAxisAlignment:
                      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      color: AppColors.background(context),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
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
                    crossAxisAlignment:
                        isRtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          textDirection:
                              isRtl ? TextDirection.rtl : TextDirection.ltr,
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
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
    final bool isRtl = LocalizationService.isRtl(context);

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'reviews.customer_reviews'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: AppColors.foreground(context),
            ),
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
              '${'reviews.see_all'.translate()} (${controller.reviews.length})',
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary(context),
                ),
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

    final bool isRtl = LocalizationService.isRtl(context);

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
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Column(
              crossAxisAlignment:
                  isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: AppColors.foreground(context),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
                  '${controller.reviews.length} ${controller.reviews.length == 1 ? 'reviews.review_singular'.translate() : 'reviews.review_plural'.translate()}',
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground(context),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        SizedBox(
                          width: 12,
                          child: Text(
                            '$ratingCount',
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mutedForeground(context),
                              ),
                            ),
                            textAlign: isRtl ? TextAlign.left : TextAlign.right,
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
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground(context),
                              ),
                            ),
                            textAlign: isRtl ? TextAlign.right : TextAlign.left,
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
    final bool isRtl = LocalizationService.isRtl(context);
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
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
              hasReviewed
                  ? 'reviews.already_reviewed'.translate()
                  : 'reviews.write_review'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color:
                      hasReviewed
                          ? AppColors.muted(context)
                          : AppColors.primary(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: UIConfig.marginMedium),
        padding: EdgeInsets.all(UIConfig.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground(context).withOpacity(0.05),
              blurRadius: UIConfig.elevationLarge,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildFormHeader(),
            SizedBox(height: UIConfig.paddingSmall),
            _buildRatingSelector(),
            SizedBox(height: UIConfig.paddingLarge),
            _buildReviewInput(),
            SizedBox(height: UIConfig.paddingMedium),
            _buildQuickTagsSection(),
            SizedBox(height: UIConfig.paddingLarge),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    final bool isRtl = LocalizationService.isRtl(context);

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'reviews.your_rating'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeMedium,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
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
            size: UIConfig.fontSizeLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTagsSection() {
    final bool isRtl = LocalizationService.isRtl(context);

    return Column(
      crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          'reviews.quick_tags'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeRegular,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
        SizedBox(height: UIConfig.paddingSmall),
        Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Wrap(
            spacing: UIConfig.paddingSmall,
            runSpacing: UIConfig.paddingSmall,
            children: _quickTags.map((tag) => _buildQuickTag(tag)).toList(),
          ),
        ),
      ],
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppColors.destructive(context),
      colorText: AppColors.destructiveForeground(context),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(UIConfig.paddingMedium),
    );
  }

  Future<void> _submitReview() async {
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'You',
      rating: _rating.value,
      content: _commentController.text,
      createdAt: DateTime.now(),
      appUserId: _currentUserId ?? 'anonymous',
    );

    await controller.addReview(widget.product.id, review);
    await controller.fetchReviews(widget.product.id);
  }

  void _resetForm() {
    _commentController.clear();
    _rating.value = 0;
    _isWritingReview.value = false;
  }

  Widget _buildRatingSelector() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () => _rating.value = index + 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIConfig.paddingSmall / 2,
              ),
              child: Icon(
                index < _rating.value
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: UIConfig.fontSize2XLarge,
                color:
                    index < _rating.value
                        ? AppColors.accent(context)
                        : AppColors.muted(context),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReviewInput() {
    final bool isRtl = LocalizationService.isRtl(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: TextField(
        controller: _commentController,
        focusNode: _commentFocusNode,
        maxLines: 1,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isRtl ? TextAlign.right : TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        style: LocalizationService.getLocalizedTextStyle(
          context,
          TextStyle(
            color: AppColors.inputForeground(context),
            fontSize: UIConfig.fontSizeRegular,
            fontFamily: 'Poppins',
          ),
        ),
        decoration: InputDecoration(
          hintText: 'reviews.share_experience'.translate(),
          hintStyle: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.mutedForeground(context),
              fontSize: UIConfig.fontSizeRegular,
              fontFamily: 'Poppins',
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(UIConfig.paddingSmall),
          isDense: true,
          filled: true,
          fillColor: AppColors.input(context),
        ),
        textInputAction: TextInputAction.done,
        onTap: _handleInputTap,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: _isSubmitting.value ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: AppColors.primaryForeground(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
            ),
            padding: EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
          ),
          child:
              _isSubmitting.value
                  ? _buildLoadingIndicator()
                  : _buildSubmitButtonText(),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: UIConfig.fontSizeLarge,
      height: UIConfig.fontSizeLarge,
      child: CircularProgressIndicator(
        color: AppColors.primaryForeground(context),
      ),
    );
  }

  Widget _buildSubmitButtonText() {
    return Text(
      'reviews.submit_review'.translate(),
      style: LocalizationService.getLocalizedTextStyle(
        context,
        TextStyle(
          fontSize: UIConfig.fontSizeMedium,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: AppColors.primaryForeground(context),
        ),
      ),
    );
  }

  void _handleInputTap() {
    setState(() => _isShimmerVisible = false);
    if (!_commentFocusNode.hasFocus && mounted) {
      _commentFocusNode.requestFocus();
    }
  }

  Future<void> _handleSubmit() async {
    if (_rating.value == 0) {
      _showError('reviews.error_rating'.translate());
      return;
    }
    if (_commentController.text.trim().isEmpty) {
      _showError('reviews.error_comment'.translate());
      return;
    }
    _isSubmitting.value = true;
    try {
      await _submitReview();
      _resetForm();
      Get.snackbar(
        'Success',
        'reviews.success_message'.translate(),
        backgroundColor: AppColors.success(context),
        colorText: AppColors.successForeground(context),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(UIConfig.paddingMedium),
      );
    } catch (e) {
      _showError('reviews.error_submit'.translate());
    } finally {
      _isSubmitting.value = false;
    }
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
        padding: EdgeInsets.symmetric(
          horizontal: UIConfig.paddingSmall * 1.5,
          vertical: UIConfig.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusXLarge),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Text(
          text,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              fontSize: UIConfig.fontSizeSmall,
              fontFamily: 'Poppins',
              color: AppColors.foreground(context),
            ),
          ),
        ),
      ),
    );
  }
}
